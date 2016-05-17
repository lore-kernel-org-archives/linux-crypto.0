From: Stephan Mueller <smueller@chronox.de>
Subject: Re: Typos and RSA
Date: Wed, 18 May 2016 00:16:55 +0200
Message-ID: <1468644.THAbu50UCt@positron.chronox.de>
References: <573B8BA3.8020902@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Gary R Hook <ghook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:39548 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191AbcEQWRG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 May 2016 18:17:06 -0400
In-Reply-To: <573B8BA3.8020902@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 17. Mai 2016, 16:22:43 schrieb Gary R Hook:

Hi Gary,

> I am working on hooking up RSA functionality to the akcipher API. It appears
> that no other code, to date, uses this API. Can anyone confirm or deny that
> conclusion?

This is not correct. The asymmetric key API uses that code. So does the module 
signing code.
> 
> I have questions about invoking akcipher transform functions, and can
> find no
> information about specifics that vex me. If there is other code to look
> at, I'm
> happy to. Otherwise, I can embarrass myself here with a display of
> ignorance.
> 
> Gary
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Ciao
Stephan
