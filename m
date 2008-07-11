From: Manish RATHI <manish.rathi@st.com>
Subject: Regarding integration with cryptodev
Date: Fri, 11 Jul 2008 09:00:12 +0530
Message-ID: <001401c8e306$6d821650$900bc70a@dlh.st.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from s200aog17.obsmtp.com ([207.126.144.131]:51955 "EHLO
	s200aog17.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbYGKDsb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Jul 2008 23:48:31 -0400
Received: from zeta.dmz-eu.st.com (ns2.st.com [164.129.230.9])
	by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id A25A9DAC1
	for <linux-crypto@vger.kernel.org>; Fri, 11 Jul 2008 03:30:16 +0000 (GMT)
Received: from mail1.dlh.st.com (mail1.dlh.st.com [10.199.8.21])
	by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 215CC4BC9B
	for <linux-crypto@vger.kernel.org>; Fri, 11 Jul 2008 03:30:15 +0000 (GMT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,
Is there any effort done to make linux crypto api to work with cryptodev?
How can I use kernel space linux crypto with user space libraries?
Does Linux crypto framework provide async APIs like OCF? What are the pros and cons of Linux crypto in comparison to OCF?
Has anybody tested openswan KLIPS patch with 2.6.24 kernel so that ipsec use OCF?

Regards
Manish

