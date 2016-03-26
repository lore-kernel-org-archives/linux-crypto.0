From: Jeffrey Walton <noloader@gmail.com>
Subject: How to detect availability of asynchronous ciphers at runtime?
Date: Sat, 26 Mar 2016 14:06:04 -0400
Message-ID: <CAH8yC8msw5y_fsBM1aGoKXqGAgKfw11YheSt4HJhWogUuZkubg@mail.gmail.com>
Reply-To: noloader@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:37320 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887AbcCZSGF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 26 Mar 2016 14:06:05 -0400
Received: by mail-ig0-f182.google.com with SMTP id l20so31637445igf.0
        for <linux-crypto@vger.kernel.org>; Sat, 26 Mar 2016 11:06:05 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Everyone,

Please forgive my ignorance here... I'm trying to detect the
availability of asynchronous ciphers support at runtime. The back
story is there's some feature tests going on based on hard coded
kernel version numbers (namely, 4.1). I feel like there's probably a
better way to go about it.

It seems like 'socket(AF_ALG, ...)' is not enough since that only
detects availability of userland crypto support.

How do I detect the availability of asynchronous ciphers at runtime?

Thank you in advance.
