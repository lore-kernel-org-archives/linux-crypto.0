From: "Shasi Pulijala" <spulijala@amcc.com>
Subject: RE: Bogus sha1 implementation in crypto4xx
Date: Wed, 29 Jul 2009 15:58:10 -0700
Message-ID: <DB599F406D04E34389140B7D99C71B1B0825B963@SDCEXCHANGE01.ad.amcc.com>
References: <20090714130600.GA11081@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>
To: "Herbert Xu" <herbert@gondor.apana.org.au>, "Loc Ho" <lho@amcc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sdcmail01.amcc.com ([198.137.200.72]:37393 "EHLO
	sdcmail01.amcc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbZG2XHv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jul 2009 19:07:51 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20090714130600.GA11081@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

>>I just noticed that the sha1 implementation in crypto4xx is
>>fundamentally broken.  It stores the hash state in the context
>>of the tfm, instead of the context of the request.

>>This means that at any one time you can only have one entity
>>using the tfm, which is infeasible for an asynchronous hash.

I am assuming you are talking about the final hash result being stored =
in the ctx of the tfm and not the intermediate hash state.=20
In any case I think we should be safe here since we have a unique packe=
t descriptor per request.
Each packet descriptor has a pointer for SA which holds a pointer for S=
tate record. This state record holds the IV and the final hash state.
In the driver=92s crypto4xx_build_pd function we get a unique packet de=
scriptor per request and a unique SA pointer location and a unique stat=
e record pointer.
The tfm=92s context SA is now copied into the packet descriptor=92s SA =
pointer and here we also assign the state record pointer to the SA.

                if (iv_len || ctx->is_hash) {
                                ivlen =3D iv_len;
                                pd->sa =3D pd_uinfo->sa_pa;
                                sa =3D (struct dynamic_sa_ctl *) pd_uin=
fo->sa_va;
                                if (ctx->direction =3D=3D DIR_INBOUND)
                                                memcpy(sa, ctx->sa_in, =
ctx->sa_len * 4);
                                else
                                                memcpy(sa, ctx->sa_out,=
 ctx->sa_len * 4);

                                memcpy((void *) sa + ctx->offset_to_sr_=
ptr,
                                                &pd_uinfo->sr_pa, 4);

If there exists an IV we then copy it to the state record.=20

                                if (iv_len)
                                                crypto4xx_memcpy_le(pd_=
uinfo->sr_va, iv, iv_len);

The above applies for digest functions for hash algorithms.

=46or init/update/final operations in the init function we save the ini=
tial digest to the tfm ctx. We follow the same the procedure for update=
 as in digest operations as well, where in we create a separate copy of=
 the tfm ctx SA in the unique packet descriptor, and the result of each=
 update function is copied into the tfm ctx SA =91s initial digest agai=
n to be used for the next operation. So even for these operations we sh=
ould be safe.

I hope we both are seeing the same problem here, if not it would be gre=
at if you could explain what's the exact problem that you are seeing.

Thanks,
-Shasi

-----Original Message-----
=46rom: Herbert Xu [mailto:herbert@gondor.apana.org.au]=20
Sent: Tuesday, July 14, 2009 6:06 AM
To: Rina Kagan; Shasi Pulijala
Cc: Linux Crypto Mailing List
Subject: Bogus sha1 implementation in crypto4xx

Hi:

I just noticed that the sha1 implementation in crypto4xx is
fundamentally broken.  It stores the hash state in the context
of the tfm, instead of the context of the request.

This means that at any one time you can only have one entity
using the tfm, which is infeasible for an asynchronous hash.

So I'm going to disable the sha1 part of crypto4xx until this
is fixed.

This hasn't caused a problem before because we haven't started
using ahash yet, apart from tcrypt which is single-threaded.
I'm currently in the process of converting authenc (hence IPsec)
across, which means that we will soon rely on the fact that
you can have multiple hash operations ongoing at once.

Thanks,
--=20
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
