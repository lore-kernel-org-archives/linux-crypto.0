From: Tobias Volk <mail@tobiasvolk.de>
Subject: padlock hardware crypto for x86_64
Date: Wed, 11 Mar 2009 22:41:22 +0100
Message-ID: <49B83002.9040705@tobiasvolk.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from lnx141.hrz.tu-darmstadt.de ([130.83.156.236]:42480 "EHLO
	lnx141.hrz.tu-darmstadt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753096AbZCKVud (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Mar 2009 17:50:33 -0400
Received: from lnx503.hrz.tu-darmstadt.de (lnx503.hrz.tu-darmstadt.de [130.83.156.232])
	by lnx141.hrz.tu-darmstadt.de (8.13.8/8.13.8) with ESMTP id n2BLno6G000904
	for <linux-crypto@vger.kernel.org>; Wed, 11 Mar 2009 22:49:50 +0100
	(envelope-from mail@tobiasvolk.de)
Received: from paris.dvs.informatik.tu-darmstadt.de (paris2.dvs.informatik.tu-darmstadt.de [130.83.166.130])
	by lnx503.hrz.tu-darmstadt.de (8.13.8/8.13.8/HRZ/PMX) with ESMTP id n2BLfOPV003822
	for <linux-crypto@vger.kernel.org>; Wed, 11 Mar 2009 22:41:24 +0100
	(envelope-from mail@tobiasvolk.de)
Received: from [1.33.7.2] (panama [130.83.166.249])
	by paris.dvs.informatik.tu-darmstadt.de (Postfix) with ESMTP id 624AA1709
	for <linux-crypto@vger.kernel.org>; Wed, 11 Mar 2009 22:41:24 +0100 (CET)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

i recently got a VIA VB8001 with their new "Nano" CPU. I just tried to
build the 2.6.28.7 Kernel in 64bit mode with padlock support... but
there seems to be none yet (i386 has the option).

Is it planned to support this in the near future?

- Tobias
