From: Harsh Jain <harshjain.prof@gmail.com>
Subject: Test AEAD/authenc algorithms from userspace
Date: Tue, 31 May 2016 12:31:16 +0530
Message-ID: <CAFXBA=kStufh3TDe=+qQYmd2tNCj9hgXLUKBeoZHBs2VxRBRbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:34170 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbcEaHBR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 May 2016 03:01:17 -0400
Received: by mail-oi0-f54.google.com with SMTP id e72so14144598oib.1
        for <linux-crypto@vger.kernel.org>; Tue, 31 May 2016 00:01:17 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi All,

How can we open socket of type "authenc(hmac(sha256),cbc(aes))" from
userspace program.I check libkcapi library. It has test programs for
GCM/CCM. There are 3 types of approaches to Authenticated Encryption,
Which of them is supported in crypto framework.

1) Encrypt-then-MAC (EtM)
     The plaintext is first encrypted, then a MAC is produced based on
the resulting ciphertext. The ciphertext and its MAC are sent
together.
2) Encrypt-and-MAC (E&M)
     A MAC is produced based on the plaintext, and the plaintext is
encrypted without the MAC. The plaintext's MAC and the ciphertext are
sent together.

3) MAC-then-Encrypt (MtE)
     A MAC is produced based on the plaintext, then the plaintext and
MAC are together encrypted to produce a ciphertext based on both. The
ciphertext (containing an encrypted MAC) is sent.


Regards
Harsh Jain
