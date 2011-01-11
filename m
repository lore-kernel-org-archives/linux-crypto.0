From: Mark Allyn <allyn@well.com>
Subject: Why are there multiple defines of scatter_walk?
Date: Tue, 11 Jan 2011 11:20:44 -0800 (PST)
Message-ID: <Pine.GSO.4.64.1101111118140.25632@well.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.well.com ([208.17.81.207]:57625 "EHLO smtp.well.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932191Ab1AKTUp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 11 Jan 2011 14:20:45 -0500
Received: from well.com (well.com [10.0.101.205])
	by smtp.well.com (8.14.3/8.14.3) with ESMTP id p0BJKhS1029889
	for <linux-crypto@vger.kernel.org>; Tue, 11 Jan 2011 11:20:43 -0800
Received: from localhost (allyn@localhost)
	by well.com (8.14.2/8.14.2/Submit) with ESMTP id p0BJKilt026521
	for <linux-crypto@vger.kernel.org>; Tue, 11 Jan 2011 11:20:44 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


I notice two defines of struct scatter_walk; one at line 20 of 
include/crypto/scatterwalk.h and the other at line 74 of 
include/crypto/algapi.h

They are not the same. Why?

Which one does a driver supposed to include?

Thanks

Mark Allyn
Portland, Oregon
www.allyn.com
971-563-7588
