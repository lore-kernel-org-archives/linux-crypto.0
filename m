From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH] crypto: remove duplicate include of linux/interrupt.h
Date: Thu, 19 Jun 2008 16:51:15 +0400
Message-ID: <20080619125115.GA10549@2ka.mipt.ru>
References: <1213879388-11418-1-git-send-email-andre@bitwigglers.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Andre Haupt <andre@bitwigglers.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:40547 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659AbYFSMvX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 Jun 2008 08:51:23 -0400
Content-Disposition: inline
In-Reply-To: <1213879388-11418-1-git-send-email-andre@bitwigglers.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi.

On Thu, Jun 19, 2008 at 02:43:08PM +0200, Andre Haupt (andre@bitwigglers.org) wrote:
> Signed-off-by: Andre Haupt <andre@bitwigglers.org>

Thank you for the patch,  but similar one from Huang Weiyi is in Herbert Xu
cryptodev-2.6 tree an will be pushed upstream in upcoming merge window.

-- 
	Evgeniy Polyakov
