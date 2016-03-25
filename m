From: Jeffrey Walton <noloader@gmail.com>
Subject: Userland crypto api test cases and test programs?
Date: Fri, 25 Mar 2016 04:49:55 -0400
Message-ID: <CAH8yC8kBn6kiowfPxjxMcOT+u2t5434LL6ia6KzhRzB6C9+Fng@mail.gmail.com>
Reply-To: noloader@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:33193 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbcCYIt5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 Mar 2016 04:49:57 -0400
Received: by mail-io0-f176.google.com with SMTP id c63so111456789iof.0
        for <linux-crypto@vger.kernel.org>; Fri, 25 Mar 2016 01:49:56 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Everyone,

I've been doing some testing of OpenSSL's upcoming 1.1.0. OpenSSL
includes an Engine wrapper for the userland crypto exposed through the
kernel's AF_ALG socket domain.

The upcoming code experiences somewhat unexplained failures on
occasion. I think its partly related to the asynchronous ciphers. For
example, trying to set the key for a skcipher results in EBUSY (device
or resource busy).

I'd like to examine the kernel's test cases and test programs to see
how things are intended to be operated. However, searching the
archives is not turning up much for past messages about it. For
example, 0 hits for "asynchronous socket tests"
(https://www.mail-archive.com/search?q=asynchronous+socket+tests&l=linux-crypto%40vger.kernel.org).

Where can I find the kernel's test cases and test programs used for
userland crypto api?

Thanks you in advance.
