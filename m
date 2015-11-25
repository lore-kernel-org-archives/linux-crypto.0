From: Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 2/2] ath9k: export HW random number generator
Date: Wed, 25 Nov 2015 11:16:22 +0200
Message-ID: <87io4qphg9.fsf@kamboji.qca.qualcomm.com>
References: <1436946847-10909-1-git-send-email-miaoqing@qca.qualcomm.com>
	<a8b787bd17d94e8899bf1be6131165b2@NASANEXM01E.na.qualcomm.com>
	<55B60BC9.8040800@rempel-privat.de>
	<3945775.m5HblJPgiO@tauon.atsec.com>
	<8738043ith.fsf@kamboji.qca.qualcomm.com>
	<3ec13417acdc48628adaedb68d259b9c@NASANEXM01E.na.qualcomm.com>
	<CAFtRNNyWzRKQbq1wa8=6V=tOQzB3g9jEBLhAO7iSchNAzf=fkQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Pan\, Miaoqing" <miaoqing@qti.qualcomm.com>,
	Stephan Mueller <smueller@chronox.de>,
	"Sepehrdad\, Pouyan" <pouyans@qti.qualcomm.com>,
	"Jacobson\, David" <djacobso@qti.qualcomm.com>,
	Oleksij Rempel <linux@rempel-privat.de>,
	"linville\@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	"linux-crypto\@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"nhorman\@tuxdriver.com" <nhorman@tuxdriver.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35594 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720AbbKYJQa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Nov 2015 04:16:30 -0500
In-Reply-To: <CAFtRNNyWzRKQbq1wa8=6V=tOQzB3g9jEBLhAO7iSchNAzf=fkQ@mail.gmail.com>
	(Nick Kossifidis's message of "Sat, 7 Nov 2015 17:39:21 -0600")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Nick Kossifidis <mickflemm@gmail.com> writes:

> That was partially my intention too when I submitted
> 2aa56cca3571fd08c0c38f3e2d4bb0bfb3def3c5 which mixes FFT measurements
> to the entropy pool without providing any estimation on entropy
> (entropy estimation is the wrong approach, read the papers on fortuna
> for more information on that). I believe that this approach is better
> than mine because FFT data is too much (high throughput) and may have
> a negative impact on the pool when mixed like this (even without the
> entropy count) so Kale please revert my patch also (I was about to
> submit a request for reverting it and writing something similar when
> this thread came up).

Could you submit the revert as a patch and with the explonation in the
commit log, please?

-- 
Kalle Valo
