From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] Use kzfree in crypto API context initialization and
 key/iv handling
Date: Sun, 31 May 2009 21:46:23 -0700 (PDT)
Message-ID: <20090531.214623.76344831.davem@davemloft.net>
References: <20090531025720.GC9033@oblivion.subreption.com>
	<20090530.230213.73434433.davem@davemloft.net>
	<4A22967C.3080304@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: research@subreption.com, linux-kernel@vger.kernel.org,
	pageexec@freemail.hu, linux-mm@kvack.org, torvalds@osdl.org,
	alan@lxorguk.ukuu.org.uk, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au
To: riel@redhat.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51211
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751093AbZFAEqX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Jun 2009 00:46:23 -0400
In-Reply-To: <4A22967C.3080304@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Rik van Riel <riel@redhat.com>
Date: Sun, 31 May 2009 10:38:52 -0400

> David Miller wrote:
>> From: "Larry H." <research@subreption.com>
>> Date: Sat, 30 May 2009 19:57:20 -0700
>> 
>>> [PATCH] Use kzfree in crypto API context initialization and key/iv
>>> handling
>> Thanks for not CC:ing the crypto list, and also not CC:'ing the
>> crypto maintainer.
>> Your submissions leave a lot to be desired, on every level.
> 
> That's a pretty roundabout way of saying "I have no
> technical objections" :)

One of those "levels" was technical.

I don't even want to think about what this does to IPSEC rule creation
rates, that that matters heavily for cell phone networks where
hundreds of thousands of nodes come in and out of the server and each
such entry requires creating 4 IPSEC rules.
