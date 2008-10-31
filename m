From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: hifn_7955 and Linux
Date: Fri, 31 Oct 2008 23:31:13 +0300
Message-ID: <20081031203113.GB32720@ioremap.net>
References: <49034927.9080803@online.de> <490B09D0.1080808@online.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Andreas Gerlich <agl@online.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tservice.net.ru ([195.178.208.66]:51144 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329AbYJaUbO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 31 Oct 2008 16:31:14 -0400
Content-Disposition: inline
In-Reply-To: <490B09D0.1080808@online.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi.

On Fri, Oct 31, 2008 at 02:36:16PM +0100, Andreas Gerlich (agl@online.de) wrote:
> But it doesn't work. I get errors when I try tu use the AES-engine
> of the hifn_795x/Chip/Module.
> 
> Can you tell me what the parameters are nessesary for cryptsetup to use
> the hifn_7955?

Please show the dmesg output for the failed command and optionally (but
very helpful) enable debug and send us its output.

-- 
	Evgeniy Polyakov
