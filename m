From: Stephan Mueller <smueller@chronox.de>
Subject: Re: Test AEAD/authenc algorithms from userspace
Date: Tue, 31 May 2016 13:55:42 +0200
Message-ID: <9391378.YBnk03kFpK@positron.chronox.de>
References: <CAFXBA=kStufh3TDe=+qQYmd2tNCj9hgXLUKBeoZHBs2VxRBRbQ@mail.gmail.com> <14797179.fHPkmVmG4b@positron.chronox.de> <CAFXBA==atCfmF53DTg0Yp6Q=K8GhtRy0HZzUG-bvzd5aVnfHuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Harsh Jain <harshjain.prof@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:35282 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754267AbcEaLzo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 May 2016 07:55:44 -0400
In-Reply-To: <CAFXBA==atCfmF53DTg0Yp6Q=K8GhtRy0HZzUG-bvzd5aVnfHuA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 31. Mai 2016, 17:22:12 schrieb Harsh Jain:

Hi Harsh,

> Hi,
> 
> 1) User can use libkcapi to write program for finup/digest.
> 2) No, kernel test for finup (not sure).
> 3) We can test all callback of new hash tfm drivers added in kernel.
> 4) My driver had issue in finup path which is not caught by kcapi test
> program :)

Can you please elaborate on the last one?

Maybe we should then extend the test app to really cover also all aspects of 
AF_ALG.

Ciao
Stephan
