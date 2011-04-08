From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] crypto: blowfish: Fixed a multi line macro issue
Date: Fri, 08 Apr 2011 10:53:51 -0700 (PDT)
Message-ID: <20110408.105351.226772899.davem@davemloft.net>
References: <1302158960-20479-1-git-send-email-aditya.shevade@gmail.com>
	<20110408124501.GB19422@gondor.apana.org.au>
	<BANLkTikGeCWy3gdeCOX+OYsjuckRMG+b+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: aditya.shevade@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39079
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751871Ab1DHRy1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Apr 2011 13:54:27 -0400
In-Reply-To: <BANLkTikGeCWy3gdeCOX+OYsjuckRMG+b+Q@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Aditya Shevade <aditya.shevade@gmail.com>
Date: Fri, 8 Apr 2011 10:46:57 -0700

> Oh, I see the problem. I forgot a semicolon in the commit file. Making
> the change.

I think it's even more important that you are submitting patches
you aren't even build testing.
