From: "Prashant Batra (prbatra)" <prbatra@cisco.com>
Subject: IPSec for data over raw socket
Date: Wed, 17 Aug 2011 22:48:58 +0530
Message-ID: <B97B134FACB2024DB45F524AB0A7B7F2042C02A9@XMB-BGL-419.cisco.com>
References: <1312481965-26484-1-git-send-email-minipli@googlemail.com> <20110810110330.GC2649@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:48371 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab1HQRTH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Aug 2011 13:19:07 -0400
Received: from xbh-bgl-412.cisco.com (xbh-bgl-412.cisco.com [72.163.129.202])
	by bgl-core-1.cisco.com (8.14.3/8.14.3) with ESMTP id p7HHJ46c008828
	for <linux-crypto@vger.kernel.org>; Wed, 17 Aug 2011 17:19:04 GMT
Content-class: urn:content-classes:message
In-Reply-To: <20110810110330.GC2649@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

	IPSec doesn't seem to work with packets sent from RAW socket.
I think this is as per the design of RAW socket, that they bypass the
transport layer. But as they enter the core IP layer,
and there is a policy to protect, they should get protected. But this
does not happen?
Any clues?

Also, if this is not possible, how can we use kernel IPSec to protect
RAW socket data.

Thanks, 
Prashant
