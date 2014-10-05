From: Sandy Harris <sandyinchina@gmail.com>
Subject: memset() in crypto code?
Date: Sat, 4 Oct 2014 23:09:40 -0400
Message-ID: <CACXcFmkQSZrQHqmcauAvpyexkjL5YpNKa-O0Or1VMuU4hawzkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:64268 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaJEDJl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 4 Oct 2014 23:09:41 -0400
Received: by mail-ig0-f179.google.com with SMTP id h18so1173655igc.6
        for <linux-crypto@vger.kernel.org>; Sat, 04 Oct 2014 20:09:40 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

There was recently a patch to the random driver to replace memset()
because, according to the submitter, gcc sometimes optimises memset()
away which might leave data unnecessarily exposed. The solution
suggested was a function called memzero_explicit(). There was a fair
bit of discussion and the patch was accepted.

In the crypto directory of the kernel source I have:

$ grep memset *.c | wc -l
133
$

I strongly suspect some of these should be fixed.
