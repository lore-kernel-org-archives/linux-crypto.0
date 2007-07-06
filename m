From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: RSA support into kernel?
Date: Fri, 6 Jul 2007 14:37:31 +0400
Message-ID: <20070706103731.GA10033@2ka.mipt.ru>
References: <f8b2ccd40707051548w275a1575oaaddffd40d9a9163@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Cc: linux-crypto@vger.kernel.org
To: Gautam Singaraju <gautam.singaraju@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:35758 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759403AbXGFKhd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Jul 2007 06:37:33 -0400
Content-Disposition: inline
In-Reply-To: <f8b2ccd40707051548w275a1575oaaddffd40d9a9163@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jul 05, 2007 at 03:48:51PM -0700, Gautam Singaraju (gautam.singaraju@gmail.com) wrote:
> Is there any attempts being made to provide software based RSA
> cryptographic support in kernel level? I see that 2.6.21 supports
> Hardware devices such as VIA Padlock ACE. Has anybody had a change to
> use such a system?

VIA padlock engine or RSA? The former is heavily used in the wild, but
why would anyone want to use RSA in the kernel?

> -GS

-- 
	Evgeniy Polyakov
