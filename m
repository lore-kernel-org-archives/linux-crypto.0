From: Andreas Jellinghaus <aj@ciphirelabs.com>
Subject: Re: [ACRYPTO] New asynchronous crypto layer (acrypto) release.
Date: Thu, 28 Sep 2006 15:23:43 +0200
Message-ID: <451BCCDF.5000201@ciphirelabs.com>
References: <20060928120826.GA18063@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.ciphirelabs.net ([217.72.114.64]:60078 "EHLO
	mx1.ciphirelabs.net") by vger.kernel.org with ESMTP
	id S1751884AbWI1NYM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Sep 2006 09:24:12 -0400
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
In-Reply-To: <20060928120826.GA18063@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Evgeniy Polyakov wrote:
> Hello.
> 
> I'm pleased to announce asynchronous crypto layer (acrypto) [1] release 
> for 2.6.18 kernel tree. Acrypto allows to handle crypto requests 
> asynchronously in hardware.
> 
> Combined patchset includes:
>  * acrypto core
>  * IPsec ESP4 port to acrypto
>  * dm-crypt port to acrypto

so I should be able to replace a plain 2.6.18 kernel with one
with this patchset and use dm-crypt'ed partitions (e.g. swap,
encrypted root filesystem) as usual without further changes?

Did anyone test this with success?

Regards, Andreas
