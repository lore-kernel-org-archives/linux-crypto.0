From: "Tan Swee Heng" <thesweeheng@gmail.com>
Subject: [PATCH 2/3] [eSTREAM] stream: Wrapper for eSTREAM ciphers
Date: Tue, 13 Nov 2007 03:59:02 +0800
Message-ID: <fd3e431c0711121159p4eec500fw5a3caec76f07295d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Linux Crypto" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:57735 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbXKLT7H (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Nov 2007 14:59:07 -0500
Received: by wa-out-1112.google.com with SMTP id v27so1649352wah
        for <linux-crypto@vger.kernel.org>; Mon, 12 Nov 2007 11:59:03 -0800 (PST)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch implements a template that wraps around an eSTREAM cipher
algorithm and its ivsize.

For example, an eSTREAM cipher with the name CIPHERNAME and ivsize
IVSIZE will be instantiated as "stream(CIPHERNAME,IVSIZE)" in
cryptomgr. It uses blkcipher to walk over the memory it
encrypts/decrypts. It has been modified to use the crypto_estream_*
type instead of crypto_cipher_*.
