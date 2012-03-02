From: Markus <nepenthesdev@gmail.com>
Subject: Re: Kernel Oops when using af_alg for SHA1
Date: Sat, 3 Mar 2012 00:00:51 +0100
Message-ID: <CACEGMv8icR7qBn8ywSknZjJeWdXOv4BwkbZbiyu8_66B9jtxcA@mail.gmail.com>
References: <013601ccf8b4$38951d80$a9bf5880$@org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-crypto@vger.kernel.org
To: Frank <frank@debian-nas.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33346 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965354Ab2CBXAw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 2 Mar 2012 18:00:52 -0500
Received: by ghrr11 with SMTP id r11so1059666ghr.19
        for <linux-crypto@vger.kernel.org>; Fri, 02 Mar 2012 15:00:51 -0800 (PST)
In-Reply-To: <013601ccf8b4$38951d80$a9bf5880$@org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

On 3/2/12, Frank <frank@debian-nas.org> wrote:
> In the process of evaluating userspace crypto APIs, I've run into a kernel
> Oops when performing a TLS handshake to openssl which offloads to AF_ALG
> (with SHA1 digests offloading to AF_ALG enabled).

Unable to reproduce on x86_64 using Ubuntu 11.04 (x86_64
2.6.38-13-generic) & stock OpenSSL 0.9.8o 01 Jun 2010 - it just works
there.

Reproduced on x86_64 using Ubuntu 11.04 (2.6.38-13-generic) & custom
OpenSSL 1.0.0d 8 Feb 2011.


Markus
