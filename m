From: "Loc Ho" <locnho@sbcglobal.net>
Subject: RE: New Crypto Hardware
Date: Mon, 21 Jan 2008 17:29:13 -0800
Message-ID: <002301c85c96$32a67a40$5c05420a@amcc.com>
References: <E1IrkmY-0007gp-00@gondolin.me.apana.org.au> <0CA0A16855646F4FA96D25A158E299D603EB866F@SDCEXCHANGE01.ad.amcc.com> <20071225073202.GA31076@gondor.apana.org.au> <0CA0A16855646F4FA96D25A158E299D603FCC15D@SDCEXCHANGE01.ad.amcc.com> <20080117112314.GC9020@gondor.apana.org.au> <001c01c85937$ff3313f0$5c05420a@amcc.com> <20080117202735.GA22733@Chamillionaire.breakpoint.cc> <0CA0A16855646F4FA96D25A158E299D603FCC4D7@SDCEXCHANGE01.ad.amcc.com> <20080118230721.GA30470@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>,
	<linux-crypto@vger.kernel.org>
To: "'Sebastian Siewior'" <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:39954 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754007AbYAVB3L (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Jan 2008 20:29:11 -0500
In-Reply-To: <20080118230721.GA30470@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

If that is the case, then in order to fully support async hashing, I would
need an async version of HASH interface and an async version of digest. Am I
correct? Do you think it will be inconsistent if it is assumed that if the
functional setkey is not called, then it is digest. If it is called, then it
is hash.

-Loc

-----Original Message-----
From: linux-crypto-owner@vger.kernel.org
[mailto:linux-crypto-owner@vger.kernel.org] On Behalf Of Sebastian Siewior
Sent: Friday, January 18, 2008 3:07 PM
To: Loc Ho
Cc: Herbert Xu; linux-crypto@vger.kernel.org
Subject: Re: New Crypto Hardware

* Loc Ho | 2008-01-17 13:25:38 [-0800]:

>>Questions:
>>2. What is the difference between digest and hash type besides one 
>>operation on transformation structure (tfm) and the other on 
>>descriptor
>(desc)?
>They are used for different things.
>Digest is something like sha1 or md5. You just feed your algoritm with 
>data and get a single result. A hash on the other hand has a key which 
>is used as a salt, a random initialization string.
>
>[LH]
>Are you referring hash as HMAC mode of MD5/SHA? For normal MD5, use 
>digest algorthm. For HMAC mode of MD5, use HASH. Is this correct?
Yes. You request them as hmac(sha1) resp. hmac(md5).

>>3. Currently, cryptodev-2.6 git doesn't work under PPC4xx development 
>>board but Denx linux latest works. Have anyone tested on PPC4xx board?
>
>Please define doesn't work.
>
>[LH]
>When I compile and load Denx Linux for my sequoia board, the Kernel 
>comes up and I get  kernel message. When I compile and load 
>cryptodev-2.6.git HEAD with the same config from Denx branch, nothing.
>It seems like cryptodev-2.6 doesn't support the sequoia board. What I 
>have to do is patch only crypto file into Denx linux and that seems to 
>work for me.
cryptodev-2.6 is almost v2.6.24-rc8 tree + cryptodev patches. If you can
boot v2.6.24-rc8 than you should have no problems with cryptodev. I don't
know the diff between denx-linux & linus-linux.

>Thanks,
>Loc

Sebastian
-
To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
the body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html
