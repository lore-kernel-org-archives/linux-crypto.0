From: "Ronen Shitrit" <rshitrit@marvell.com>
Subject: status of async crypto
Date: Sun, 5 Aug 2007 13:50:48 +0300
Message-ID: <B9FFC3F97441D04093A504CEA31B7C4101AA34D2@msilexch01.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shoshil.marvell.com ([199.203.130.250]:14734 "EHLO
	il.marvell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755660AbXHEKvZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 5 Aug 2007 06:51:25 -0400
Received: from msilexch01.marvell.com (msilexch01.il.marvell.com [10.4.5.104])
	by il.marvell.com (8.13.1/8.13.1) with ESMTP id l75ApOS0010035
	for <linux-crypto@vger.kernel.org>; Sun, 5 Aug 2007 13:51:24 +0300 (IDT)
Content-class: urn:content-classes:message
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi all

Until recently I was using kernel 2.6.12 with the OCF package in order
to 
get async encryption with HW engine for OpenSWAN, dm-crypt and OpenSSL.

Lately I have decided its time to move on to the latest kernel, and I
found 
that there is a new async crypto support in the kernel :)

Now I have to decide whether to use the OCF or the native async crypto.
I have some questions and I would really appreciate if you can help
here:

I saw that the current code support async crypto for the dm-crypt, does
it
also support async crypto for the klips?
Is there any support for using the async crypto from the OpenSSL engine
library?
I saw that the async crypto support block cipher, does it also support
digest operations?
Can it support encryption + authentication (lets say AES-SHA1) as one
operation?
Is there any Documentation available? (I guess not)
What is the todo list for further development of the async crypto
support?
 
Thanks for your advice
Ronen Shitrit
