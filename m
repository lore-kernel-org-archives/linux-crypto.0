From: avital sela <avitalsela95@gmail.com>
Subject: Re: question about sha1 driver
Date: Wed, 30 Sep 2009 09:28:01 +0200
Message-ID: <311e0d1f0909300028n4e53d11ep985f7179684146d8@mail.gmail.com>
References: <311e0d1f0909210158k5feca8b9gc3b9d187e13ba6ff@mail.gmail.com>
	 <20090922031705.GA27429@gondor.apana.org.au>
	 <311e0d1f0909220617r66cc96b3s52ee3ab99bcbd6e3@mail.gmail.com>
	 <20090922142059.GC694@gondor.apana.org.au>
	 <311e0d1f0909280831j5e12671na709db1eaed5e393@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:59681 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237AbZI3H17 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 30 Sep 2009 03:27:59 -0400
Received: by bwz6 with SMTP id 6so2573989bwz.37
        for <linux-crypto@vger.kernel.org>; Wed, 30 Sep 2009 00:28:01 -0700 (PDT)
In-Reply-To: <311e0d1f0909280831j5e12671na709db1eaed5e393@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Sep 28, 2009 at 5:31 PM, avital sela <avitalsela95@gmail.com> w=
rote:
>
> Hi Herbert,
>
> This is the error message I'm getting with the unmodifed testmgr:
>
> alg: hash: Test 3 failed for hmac(sha1-hw)
>
> 00000000: d6 bf 3f 79 2a 14 11 24 f0 5c 3b 80 7e 81 08 fe
>
> 00000010: 09 ba 7a fb
>
> Attached below is the source code for the sha driver.=A0 Like I said =
previously, if I add printk-s or delays in testmgr then the test passes=
 and all subsequent sha1 crypto operations are successful.
>
> Thanks for your help,
> Avital
>
> static void hw_sha1_init(struct crypto_tfm *tfm)
> {
> =A0=A0=A0 struct hw_sha1_ctx=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=
=A0=A0 *sctx =3D crypto_tfm_ctx(tfm);
> =A0=A0=A0 unsigned long =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=
=A0 =A0=A0=A0 sha_cmd;
> =A0=A0=A0 static const struct hw_sha1_ctx initstate =3D {
> =A0=A0=A0 =A0 0,
> =A0=A0=A0 =A0 { SHA1_H0, SHA1_H1, SHA1_H2, SHA1_H3, SHA1_H4 },
> =A0=A0=A0 =A0 { 0, }
> =A0=A0=A0 };
>
> =A0=A0=A0 *sctx =3D initstate;
>
> =A0=A0=A0 /* construct SHA HW command */
> =A0=A0=A0 sha_cmd =3D=A0=A0=A0 SHA_MEM_MODE_DMA_CPU2K=A0=A0=A0=A0 |
> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 SHA_IPSEC_OP_SEL_ENCRYPT=A0=A0=
 |
> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 SHA_MODE_SHA1=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 |
> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 SHA_REV_BIT_OFF=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 |
> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 (SET_SHA_CONTROL_REG_END_SEL(=
0x77))=A0=A0 ;
> =A0=A0 SHA_HW_WRITE(SHA_CONTROL_REG,sha_cmd);
>
> }
>
> static void hw_sha1_update(struct crypto_tfm *tfm, const u8 *data,uns=
igned int len)
> {
> =A0=A0 struct hw_sha1_ctx=A0=A0=A0 =A0=A0=A0 *sctx;
>
> =A0=A0 /* copy the new chunk of data to the HW buffer */
> =A0=A0 sctx =3D crypto_tfm_ctx(tfm);
> =A0=A0 memcpy((void*)(SHA_DATA_BUFFER + (unsigned long)sctx->count),(=
void*)data,len);
> =A0=A0 sctx->count +=3D len;
> }
>
> static void hw_sha1_final(struct crypto_tfm *tfm, u8 *out)
> {
> =A0=A0 unsigned long=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 length;
> =A0=A0 struct hw_sha1_ctx=A0=A0=A0 =A0=A0=A0 *sctx;
>
> =A0=A0 sctx =3D crypto_tfm_ctx(tfm);
>
> =A0=A0 SHA_HW_WRITE(SHA_MESSAGE_SIZE_REG,sctx->count);
> =A0=A0 SHA_HW_WRITE(SHA_START_REG,0x0);
> =A0=A0 SHA_HW_WAIT_FOR_DONE();
> =A0=A0 memcpy((void*)out,(void*)SHA_DATA_BUFFER,20);
>
> =A0=A0 /* Wipe context */
> =A0=A0 memset(sctx, 0, sizeof *sctx);
> }
>
> static struct crypto_alg hw_sha1_alg =3D {
> =A0=A0=A0 .cra_name=A0=A0=A0 =A0=A0=A0 =3D=A0=A0=A0 "sha1",
> =A0=A0=A0 .cra_driver_name=3D=A0=A0=A0 "sha1-hw",
> =A0=A0=A0 .cra_flags=A0=A0=A0 =A0=A0=A0 =3D=A0=A0=A0 CRYPTO_ALG_TYPE_=
DIGEST,
> =A0=A0=A0 .cra_priority=A0=A0=A0 =3D=A0=A0=A0 300,
> =A0=A0=A0 .cra_blocksize=A0=A0=A0 =3D=A0=A0=A0 SHA1_BLOCK_SIZE,
> =A0=A0=A0 .cra_ctxsize=A0=A0=A0 =3D=A0=A0=A0 sizeof(struct hw_sha1_ct=
x),
> =A0=A0=A0 .cra_module=A0=A0=A0 =A0=A0=A0 =3D=A0=A0=A0 THIS_MODULE,
> =A0=A0=A0 .cra_list=A0=A0=A0=A0=A0=A0 =3D=A0=A0 LIST_HEAD_INIT(hw_sha=
1_alg.cra_list),
> =A0=A0=A0 .cra_u=A0=A0=A0 =A0=A0=A0 =3D
> =A0=A0=A0 {
> =A0=A0=A0 =A0=A0=A0 .digest =3D
> =A0=A0=A0 =A0=A0=A0 {
> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 .dia_digestsize=A0=A0=A0 =3D=A0=A0=A0 S=
HA1_DIGEST_SIZE,
> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 .dia_init=A0=A0 =A0=A0=A0 =3D =A0=A0=A0=
 hw_sha1_init,
> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 .dia_update =A0=A0=A0 =3D=A0=A0=A0 hw_s=
ha1_update,
> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 .dia_final=A0 =A0=A0=A0 =3D=A0=A0=A0 hw=
_sha1_final
> =A0=A0=A0 =A0=A0=A0 }
> =A0=A0=A0 }
> };
>
> /*
> =A0* =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =A0* This is the module's init function
> =A0* =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =A0*/
>
> static int __init percello_SHA_init_module (void) {
> =A0 int =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=
=A0=A0 ret =3D 0;
>
> =A0 return crypto_register_alg(&hw_sha1_alg);;
> }
>
>
>
>
>
>
>
>
>
> On Tue, Sep 22, 2009 at 4:20 PM, Herbert Xu <herbert@gondor.apana.org=
=2Eau> wrote:
>>
>> On Tue, Sep 22, 2009 at 04:17:20PM +0300, avital sela wrote:
>> >
>> > Any ideas as to what could be the reason for the failure?
>>
>> I don't see the failure message in your testmgr output?
>>
>> Please also attach your source code as otherwise it'd be impossible
>> to guess.
>>
>> Thanks,
>> --
>> Visit Openswan at http://www.openswan.org/
>> Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
>> Home Page: http://gondor.apana.org.au/~herbert/
>> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
