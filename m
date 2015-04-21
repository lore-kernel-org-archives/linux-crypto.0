From: Milan Broz <gmazyland@gmail.com>
Subject: Re: Cipher block questions
Date: Tue, 21 Apr 2015 10:07:47 +0200
Message-ID: <55360553.5040102@gmail.com>
References: <20150421072734.GA9043@arch.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: jonathan.thieuleux@gmail.com, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:32988 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbbDUIHv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Apr 2015 04:07:51 -0400
Received: by wiax7 with SMTP id x7so101187641wia.0
        for <linux-crypto@vger.kernel.org>; Tue, 21 Apr 2015 01:07:49 -0700 (PDT)
In-Reply-To: <20150421072734.GA9043@arch.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 04/21/2015 09:27 AM, jonathan.thieuleux@gmail.com wrote:
> I'm implementing a new cipher block within the kernel and I'm stuck into a
> problem. My algorithm works pretty well, it can cipher and decipher a block. The
> algorithm also works with ECB, CBC, and CTR modes, however when I try to use the
> modes such as XTS or LRW I have the following errors which are attached. Did I
> need to add more code to make it work with XTS and other modes ?

First, from the cryptsetup log
  # Userspace crypto wrapper cannot use gost-xts-plain64 (-2).
it seems that there is some problem with loading of your gost cipher implementation.

What key size you are using in cryptsetup (default is probably 256bit)?

LRW and XTS modes requires *two* keys in fact (tweaking+encryption).

GOST should use 256bit key, so if you add --key-size 512 to your cryptsetup command
does it help?

Milan
