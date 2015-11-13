From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 1/4] lib/mpi: only require buffers as big as needed for the integer
Date: Fri, 13 Nov 2015 13:47:03 +0100
Message-ID: <1971326.IIk0rEidCT@tauon.atsec.com>
References: <1447412495-4370-1-git-send-email-andrew.zaborowski@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Andrew Zaborowski <andrew.zaborowski@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34520 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754650AbbKMMrH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Nov 2015 07:47:07 -0500
In-Reply-To: <1447412495-4370-1-git-send-email-andrew.zaborowski@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 13. November 2015, 12:01:32 schrieb Andrew Zaborowski:

Hi Andrew,

>Since mpi_write_to_sgl and mpi_read_buffer explicitly left-align the
>integers being written it makes no sense to require a buffer big enough for
>the number + the leading zero bytes which are not written.  The error
>returned also doesn't convey any information.  So instead require only the
>size needed and return -EOVERFLOW to signal when buffer too short.

Sorry to be picky here, but is this v2? If yes, may I ask (at least for the 
future) for brief notation of the changes as well as a marking of the patches.

Ciao
Stephan
