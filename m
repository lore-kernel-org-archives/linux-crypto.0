From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Subject: Re: How to detect availability of asynchronous ciphers at runtime?
Date: Sat, 26 Mar 2016 20:09:25 +0200
Message-ID: <56F6D055.1040405@mentor.com>
References: <CAH8yC8msw5y_fsBM1aGoKXqGAgKfw11YheSt4HJhWogUuZkubg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: <noloader@gmail.com>, <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:35271 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264AbcCZSJ3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 26 Mar 2016 14:09:29 -0400
In-Reply-To: <CAH8yC8msw5y_fsBM1aGoKXqGAgKfw11YheSt4HJhWogUuZkubg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 26.03.2016 20:06, Jeffrey Walton wrote:
> Hi Everyone,
> 
> Please forgive my ignorance here... I'm trying to detect the
> availability of asynchronous ciphers support at runtime. The back
> story is there's some feature tests going on based on hard coded
> kernel version numbers (namely, 4.1). I feel like there's probably a
> better way to go about it.
> 
> It seems like 'socket(AF_ALG, ...)' is not enough since that only
> detects availability of userland crypto support.
> 
> How do I detect the availability of asynchronous ciphers at runtime?
> 
> Thank you in advance.

Try this method:

# cat /proc/crypto | egrep '^(name|driver|async|$)'

--
With best wishes,
Vladimir
