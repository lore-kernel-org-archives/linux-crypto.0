From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Subject: Re: [PATCH] crypto: compress - Add pcomp interface
Date: Wed, 14 Jan 2009 22:38:55 +0530
Message-ID: <3f9a31f40901140908v6da1e28cpeb951d162433d82c@mail.gmail.com>
References: <1231862386-11128-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
	 <1231862386-11128-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
	 <3f9a31f40901140845r6a0cd136ha27304c76001d1c7@mail.gmail.com>
	 <Pine.LNX.4.64.0901141753090.31703@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:14792 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765048AbZANRI4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Jan 2009 12:08:56 -0500
In-Reply-To: <Pine.LNX.4.64.0901141753090.31703@vixen.sonytel.be>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 14, 2009 at 10:24 PM, Geert Uytterhoeven
<Geert.Uytterhoeven@sonycom.com> wrote:
> On Wed, 14 Jan 2009, Jaswinder Singh Rajput wrote:
>> On Tue, Jan 13, 2009 at 9:29 PM, Geert Uytterhoeven
>> <Geert.Uytterhoeven@sonycom.com> wrote:
>> > +static inline struct pcomp_alg *crypto_pcomp_alg(struct crypto_pcomp *tfm)
>> > +{
>> > +       return __crypto_pcomp_alg(crypto_pcomp_tfm(tfm)->__crt_alg);
>> > +}
>> > +
>> > +static inline int crypto_pcomp_setup(struct crypto_pcomp *tfm,
>> > +                                    const void *params)
>> > +{
>> > +       return crypto_pcomp_alg(tfm)->setup(crypto_pcomp_tfm(tfm), params);
>> > +}
>> > +
>> > +static inline int crypto_pcomp_compress_init(struct crypto_pcomp *tfm)
>> > +{
>> > +       return crypto_pcomp_alg(tfm)->compress_init(crypto_pcomp_tfm(tfm));
>> > +}
>> > +
>> > +static inline int crypto_pcomp_compress_update(struct crypto_pcomp *tfm,
>> > +                                              struct comp_request *req)
>> > +{
>> > +       return crypto_pcomp_alg(tfm)->compress_update(crypto_pcomp_tfm(tfm),
>> > +                                                     req);
>> > +}
>> > +
>> > +static inline int crypto_pcomp_compress_final(struct crypto_pcomp *tfm,
>> > +                                             struct comp_request *req)
>> > +{
>> > +       return crypto_pcomp_alg(tfm)->compress_final(crypto_pcomp_tfm(tfm),
>> > +                                                    req);
>> > +}
>> > +
>> > +static inline int crypto_pcomp_decompress_init(struct crypto_pcomp *tfm)
>> > +{
>> > +       return crypto_pcomp_alg(tfm)->decompress_init(crypto_pcomp_tfm(tfm));
>> > +}
>> > +
>> > +static inline int crypto_pcomp_decompress_update(struct crypto_pcomp *tfm,
>> > +                                                struct comp_request *req)
>> > +{
>> > +       return crypto_pcomp_alg(tfm)->decompress_update(crypto_pcomp_tfm(tfm),
>> > +                                                       req);
>> > +}
>> > +
>> > +static inline int crypto_pcomp_decompress_final(struct crypto_pcomp *tfm,
>> > +                                               struct comp_request *req)
>> > +{
>> > +       return crypto_pcomp_alg(tfm)->decompress_final(crypto_pcomp_tfm(tfm),
>> > +                                                      req);
>> > +}
>>
>> Can you please use expressive but short names ?
>
> I admit they're quite long. But they're similar to the ones in use for the
> already existing crypto modules.
>

But I am expecting better results from you ;-)

Thanks
--
JSR
