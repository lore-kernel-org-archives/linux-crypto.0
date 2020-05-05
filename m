Return-Path: <SRS0=vF1r=6T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5088C47254
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 08:05:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3602F206CC
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 08:05:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="jpT1rsfp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgEEIFX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 May 2020 04:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725766AbgEEIFX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 May 2020 04:05:23 -0400
Received: from mo6-p00-ob.smtp.rzone.de (mo6-p00-ob.smtp.rzone.de [IPv6:2a01:238:20a:202:5300::9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AADAC061A0F
        for <linux-crypto@vger.kernel.org>; Tue,  5 May 2020 01:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1588665919;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=CqAp08JDWlIPFPJWYIgyebvOeDMm3QFnMT+FajBB+Vg=;
        b=jpT1rsfpQvYEdPUUwOtm/HAv5IXdplX9i8iAai/avyS2krgFpmBR/hSMA6pmTGotIS
        ZmkQoBqTARs0EAbrTo8QVGxkjS1DH3vw+Sx3zxmajQDJKsw17E6Pew4jg0Xro3hviMaY
        3nY2ufMqNSaCxAeGQyv3f8R/MNlE1fJj083QZ67PDLGcNi7OpWKwoZZoPOTyTbFWUhr4
        BALDC2weilYqP13ImjuyuVHYrggj2tHvC5MxgBl0aOsUedrPLktTeb5AY3bVToNH1pO4
        VKgI0KKv+XzwK0aprtYjRBRguSmOTeUnYeelFQzEkPKzPZeayYXB070TGFGUenPp8cuU
        dc/w==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPZJ/Sc+igB"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.6.2 DYNA|AUTH)
        with ESMTPSA id u08bf3w4585D848
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 5 May 2020 10:05:13 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ondrej =?utf-8?B?TW9zbsOhxI1law==?= <omosnacek@gmail.com>,
        linux-crypto@vger.kernel.org, Sahana Prasad <saprasad@redhat.com>,
        Tomas Mraz <tmraz@redhat.com>, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: libkcapi tests are failing on kernels 5.5+
Date:   Tue, 05 May 2020 10:05:13 +0200
Message-ID: <2747000.ThacN6qak4@tauon.chronox.de>
In-Reply-To: <20200505075834.GA1190@gondor.apana.org.au>
References: <CAAUqJDvZt7_j+eor1sXRg+QmrdXTjMiymFnji86PoatsYPUugA@mail.gmail.com> <20200505075834.GA1190@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Dienstag, 5. Mai 2020, 09:58:35 CEST schrieb Herbert Xu:

Hi Herbert,

> On Tue, Apr 21, 2020 at 10:08:14AM +0200, Ondrej Mosn=C3=A1=C4=8Dek wrote:
> > Hi all,
> >=20
> > the libkcapi [1] tests are failing on kernels 5.5-rc1 and above [2].
> > All encryption/decryption tests that use 'ctr(aes)' and a message size
> > that is not a multiple of 16 fail due to kcapi-enc returning different
> > output than expected.
> >=20
> > It seems that it started with:
> > commit 5b0fe9552336338acb52756daf65dd7a4eeca73f
> > Author: Herbert Xu <herbert@gondor.apana.org.au>
> > Date:   Tue Sep 10 11:42:05 2019 +1000
> >=20
> >     crypto: algif_skcipher - Use chunksize instead of blocksize
> >=20
> > Reverting the above commit makes the tests pass again.
> >=20
> > Here is a one-line reproducer:
> > head -c 257 /dev/zero | kcapi-enc -vvv --pbkdfiter 1 -p "passwd" -s
> > "123" -e -c "ctr(aes)" --iv "0123456789abcdef0123456789abcdef"
> >=20
> > >/dev/null
> >=20
> > Output without revert:
> > [...]
> > libkcapi - Debug: AF_ALG: recvmsg syscall returned 256
> > kcapi-enc - Verbose: Removal of padding disabled
> > kcapi-enc - Verbose: 256 bytes of ciphertext created
>=20
> OK, I tried it here and the problem is that kcapi-enc is setting
> the flag SPLICE_F_MORE:
>=20
> splice(4, NULL, 6, NULL, 257, SPLICE_F_MORE) =3D 257
> write(2, "libkcapi - Debug: AF_ALG: splice"..., 54libkcapi - Debug: AF_AL=
G:
> splice syscall returned 257 ) =3D 54
> write(2, "kcapi-enc - Debug: Data size exp"..., 59kcapi-enc - Debug: Data
> size expected to be generated: 257 ) =3D 59
> recvmsg(6, {msg_name=3DNULL, msg_namelen=3D0,
> msg_iov=3D[{iov_base=3D"\363\212\340S\r\231\371+\234\320\"\360}%\244\242.=
\365iJ
> \304\257\210\f\366\20\257'F\5EP"..., iov_len=3D257}], msg_iovlen=3D1,
> msg_controllen=3D0, msg_flags=3D0}, 0) =3D 256
>=20
> That flag means that the request is not finished and because of
> the way CTR works we must wait for more input before returning
> the next block (or partial block).
>=20
> So kcapi-enc needs to unset the SPLICE_F_MORE to finish a request.

Thanks a lot, let me work on that.
>=20
> Cheers,


Ciao
Stephan


