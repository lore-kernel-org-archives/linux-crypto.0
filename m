From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 2/2] ath9k: export HW random number generator
Date: Mon, 27 Jul 2015 13:01:46 +0200
Message-ID: <3945775.m5HblJPgiO@tauon.atsec.com>
References: <1436946847-10909-1-git-send-email-miaoqing@qca.qualcomm.com> <a8b787bd17d94e8899bf1be6131165b2@NASANEXM01E.na.qualcomm.com> <55B60BC9.8040800@rempel-privat.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Pan, Miaoqing" <miaoqing@qti.qualcomm.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, linux-crypto@vger.kernel.org,
	nhorman@tuxdriver.com
To: Oleksij Rempel <linux@rempel-privat.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:48026 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194AbbG0LBt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 27 Jul 2015 07:01:49 -0400
In-Reply-To: <55B60BC9.8040800@rempel-privat.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 27. Juli 2015, 12:45:29 schrieb Oleksij Rempel:

Hi Oleksij,

>Am 27.07.2015 um 08:50 schrieb Pan, Miaoqing:
>>  =E2=80=9Cfips_run_rng_test=E2=80=9D  is legacy code, recommend to d=
isable 'FIPS 140-2'
>>  test if to use 'rngd-tools=E2=80=99.
>Ok, lets try simple compression. will it find enough pattern to do
>compression?
>Here what i get on my system:
>output from /dev/random
>-rw-rw-r-- 1 lex lex 2501678 Jul 27 12:01 random.out
>-rw-rw-r-- 1 lex lex 2512892 Jul 27 12:01 random.out.bz2
>
>after compression we got bigger file. i would expect it since we need =
to
>store bzip header somewhere.
>
>output from /dev/hwrng
>-rw-rw-r-- 1 lex lex 2564096 Jul 27 11:36 hwrng.out
>-rw-rw-r-- 1 lex lex 2468394 Jul 27 11:36 hwrng.out.bz2
>
>Do i understand it correctly, in case of hwrng bzip was able to find
>enough pattern to compressed the data? Even with format overhead?
>
>I'm no an expert, help of an expert would be welcome, added some more
>people to CC

This one does not look good for a claim that the RNG produces white noi=
se. An=20
RNG that is wired up to /dev/hwrng should produce white noise. Either b=
y=20
having an appropriate noise source or by conditioning the output of the=
 noise=20
source.

When conditioning the output, you have to be careful about the entropy =
claim.=20
=46or example, you cannot state that the data stream from your noise so=
urce has=20
close to one bit of entropy for each obtained bit. Thus, the conditione=
r must=20
ensure that the data from the noise source is collected and its entropy=
 is=20
maintained and accumulated.

However, the hwrandom framework does not provide any conditioning logic=
=2E And I=20
would say that such conditioner logic should not reside in a driver eit=
her. I=20
would say that the discussed RNG does not seem fit for hooking it up wi=
th the=20
hwrandom framework.

Ciao
Stephan
