From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: PATCH: SEED cipher support
Date: Sun, 12 Aug 2007 19:31:53 +0400
Message-ID: <20070812153152.GA3595@2ka.mipt.ru>
References: <20070812151130.GA37318@FreeBSD.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Hye-Shik Chang <perky@FreeBSD.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:33757 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759656AbXHLPb7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 12 Aug 2007 11:31:59 -0400
Content-Disposition: inline
In-Reply-To: <20070812151130.GA37318@FreeBSD.org>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi.

On Mon, Aug 13, 2007 at 12:11:30AM +0900, Hye-Shik Chang (perky@FreeBSD.org) wrote:
> Hello,
> 
> Here I propose a patch for linux crypto API to add a support SEED
> (RFC4269).  This patch was generated against git-HEAD as of today.
> This patch have been used in few VPN appliance vendors in Korea for
> several years.  And it was verified by KISA, who developed the
> algorithm itself.
> 
> As its importance in Korean banking industry, it would be great
> if linux incorporates the support.

Besides the only c++ comment in the tcrypt.c this patch
looks really good. This is a good submission.
As a side note: please do not send gzipped patches, since it is quite
hard to show where the problem in the patch is if any when replying.

-- 
	Evgeniy Polyakov
