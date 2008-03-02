From: Stefan Hellermann <stefan@the2masters.de>
Subject: Re: [PATCH] [crypto] XTS: use proper alignment.
Date: Sun, 02 Mar 2008 15:04:29 +0100
Message-ID: <47CAB3ED.4090802@the2masters.de>
References: <1203850864-16681-1-git-send-email-sebastian@breakpoint.cc> <47C15AEC.5040705@the2masters.de> <20080224125117.GA17076@Chamillionaire.breakpoint.cc> <47C1CE67.70804@the2masters.de> <20080302112004.GA16659@Chamillionaire.breakpoint.cc> <47CA97D5.8090804@the2masters.de> <20080302132202.GB16659@Chamillionaire.breakpoint.cc> <47CAB084.6060607@the2masters.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp10.unit.tiscali.de ([213.205.33.46]:42929 "EHLO
	smtp10.unit.tiscali.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbYCBOEn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 2 Mar 2008 09:04:43 -0500
In-Reply-To: <47CAB084.6060607@the2masters.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> 
> I tried lrw-benbi/lrw-plain this time, but it doesn't work, with or without padlock_aes.
> dmesg logs:
> device-mapper: table: 252:6: crypt: Error allocating crypto tfm
> device-mapper: ioctl: error adding target to table
> device-mapper: ioctl: device doesn't appear to be in the dev hash table
> 

forget this ... with CONFIG_CRYPTO_LRW unset it can't work. But with your new patch it
works even with padlock_aes.


Thanks
Stefan
