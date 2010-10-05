From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: crypto: return codes
Date: Tue, 05 Oct 2010 16:04:38 -0400
Message-ID: <1286309078.2663.42.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-crypto <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:39822 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647Ab0JEUEm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Oct 2010 16:04:42 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id o95JsFVR001167
	for <linux-crypto@vger.kernel.org>; Tue, 5 Oct 2010 13:54:15 -0600
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id o95K4eLZ247932
	for <linux-crypto@vger.kernel.org>; Tue, 5 Oct 2010 14:04:41 -0600
Received: from d03av05.boulder.ibm.com (loopback [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o95K4eVT017590
	for <linux-crypto@vger.kernel.org>; Tue, 5 Oct 2010 14:04:40 -0600
Received: from [9.2.19.235] (dyn9002019235.watson.ibm.com [9.2.19.235])
	by d03av05.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id o95K4eRZ017539
	for <linux-crypto@vger.kernel.org>; Tue, 5 Oct 2010 14:04:40 -0600
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

Looking at different examples of the same crypto call, it's unclear
whether it only returns negative error values. Some examples only test
for negative values, while others test for not 0. tcrypt.c does "if
(ret)".  Would appreciate some clarification.

thanks,

Mimi
