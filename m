From: Gary R Hook <ghook@amd.com>
Subject: Typos and RSA
Date: Tue, 17 May 2016 16:22:43 -0500
Message-ID: <573B8BA3.8020902@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0054.outbound.protection.outlook.com ([207.46.100.54]:22023
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751054AbcEQV4e (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 May 2016 17:56:34 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I am working on hooking up RSA functionality to the akcipher API. It appears
that no other code, to date, uses this API. Can anyone confirm or deny that
conclusion?

I have questions about invoking akcipher transform functions, and can 
find no
information about specifics that vex me. If there is other code to look 
at, I'm
happy to. Otherwise, I can embarrass myself here with a display of 
ignorance.

Gary
