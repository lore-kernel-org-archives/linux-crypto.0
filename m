From: Linus Walleij <linus.ml.walleij@gmail.com>
Subject: Userspace API /dev/crypto
Date: Tue, 12 Jan 2010 21:37:31 +0100
Message-ID: <63386a3d1001121237s3e7c4b19g82ead5dc9dc7f63c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:62930 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab0ALUhe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jan 2010 15:37:34 -0500
Received: by bwz27 with SMTP id 27so1488211bwz.21
        for <linux-crypto@vger.kernel.org>; Tue, 12 Jan 2010 12:37:32 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

IMO the design discussion of a user space API in:
http://marc.info/?l=linux-crypto-vger&m=121088311223921&w=2
"Userspace API proposal"

And the consequent attempt at a patch for OpenSSL in:
http://marc.info/?l=linux-crypto-vger&m=121822090729047&w=2
"OpenSSL patch to support Linux CryptoAPI"

Was a first nice draft of a desirable userspace API for various crypto/hash
acceleration.

Has there been some/any progress on the userspace API since, or
is this up for grabs?

Yours,
Linus Walleij
