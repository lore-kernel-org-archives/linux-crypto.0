From: "Bhaskara Peela" <bhaskara.peela@broadcom.com>
Subject: How to use Linux Crypto API when we already registered with
 Hardware Crypto API
Date: Wed, 30 Dec 2009 12:23:37 -0800
Message-ID: <197D517E3C8D504283188E2A751290E86F05A366E2@IRVEXCHCCR02.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1444 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393AbZL3UXr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 30 Dec 2009 15:23:47 -0500
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,
 
I am using 2.6.30 kernel.  I have registered some IPSec crypto/auth algorithms(ex: 3DES/MD5) supported by hardware with linux.  I want to verify the hardware crypto/authentication output with that of linux Crypto API.  To do this, I want to send same kind of IPSec packet to hardware crypto engine and linux Crypto API and compare the output.
 
I know, I can do this, by building two images one with hardware acceleration and one without it.   But, I want to do this run time so that it can be fast and i can use single image.  Can you suggest a way to do this in esp4.c ?
 
thanks
bhaskara
