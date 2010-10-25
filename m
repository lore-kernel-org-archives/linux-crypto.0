From: Mark Allyn <allyn@well.com>
Subject: General questions on crypto
Date: Mon, 25 Oct 2010 16:35:31 -0700 (PDT)
Message-ID: <Pine.GSO.4.64.1010251627060.2377@well.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.well.com ([208.17.81.207]:44095 "EHLO smtp.well.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757394Ab0JYXuS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Oct 2010 19:50:18 -0400
Received: from well.com (well.com [10.0.101.205])
	by smtp.well.com (8.14.3/8.14.3) with ESMTP id o9PNZVxS026628
	for <linux-crypto@vger.kernel.org>; Mon, 25 Oct 2010 16:35:31 -0700
Received: from localhost (allyn@localhost)
	by well.com (8.14.2/8.14.2/Submit) with ESMTP id o9PNZVjO004482
	for <linux-crypto@vger.kernel.org>; Mon, 25 Oct 2010 16:35:31 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Folks:

I am trying to understand how to implement an ahash instance for a 
hardware encryption device.

I notice that the in-kernel documentation has no mention of ahash.

Does anyone know where I can find a basic how-to document on putting
together an ahash implementation in an existing driver?

The sha1_generic that is supplied appears to be using shash, is there an 
example for ahash?

Thanks

Truly,

Mark Allyn
Portland, Oregon
www.allyn.com
971-563-7588
