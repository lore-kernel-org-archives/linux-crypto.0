From: Mark Allyn <allyn@well.com>
Subject: Question on structures
Date: Mon, 25 Oct 2010 16:45:21 -0700 (PDT)
Message-ID: <Pine.GSO.4.64.1010251641420.2377@well.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.well.com ([208.17.81.207]:45481 "EHLO smtp.well.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873Ab0JYXpW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Oct 2010 19:45:22 -0400
Received: from well.com (well.com [10.0.101.205])
	by smtp.well.com (8.14.3/8.14.3) with ESMTP id o9PNjKcG032485
	for <linux-crypto@vger.kernel.org>; Mon, 25 Oct 2010 16:45:20 -0700
Received: from localhost (allyn@localhost)
	by well.com (8.14.2/8.14.2/Submit) with ESMTP id o9PNjL0g006825
	for <linux-crypto@vger.kernel.org>; Mon, 25 Oct 2010 16:45:21 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Folks:

Perhaps this is due to me being a neophyte . . .

I notice that some of the structure have two different sets of functions.

For example, the ahash_alg structure has .init and then .base.cra_init. 
What is the difference between the two?

Thanks

Truly,

Mark Allyn
Portland, Oregon
www.allyn.com
971-563-7588
