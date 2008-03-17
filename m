From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [patch 2/2] zcrypt: add support for large random numbers
Date: Mon, 17 Mar 2008 10:44:10 +0100
Message-ID: <1205747051.16137.21.camel@localhost>
References: <20080314092523.147382820@de.ibm.com>
	 <20080314093046.914555041@de.ibm.com>
	 <20080314091402.fa409ac7.randy.dunlap@oracle.com>
Reply-To: schwidefsky@de.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-s390@vger.kernel.org, Ralph Wuerthner <rwuerthn@de.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:25520 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbYCQIoW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Mar 2008 04:44:22 -0400
In-Reply-To: <20080314091402.fa409ac7.randy.dunlap@oracle.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 2008-03-14 at 09:14 -0700, Randy Dunlap wrote:
> Linux kernel uses "/**" to indicate the beginning of kernel-doc
> notation, so when the comment block is not kernel-doc, please don't
> use that /** to begin the comment block.
> (multiple occurrences of this)

True. This is done consistently wrong in the zcrypt driver. I would
prefer to do a separate kernel-doc cleanup patch and leave this patch as
it is. Ok ?

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


