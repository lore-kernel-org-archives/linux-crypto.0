From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v4 1/6] SP800-90A Deterministic Random Bit Generator
Date: Fri, 11 Apr 2014 21:24:17 +0200
Message-ID: <1954196.dS1rBRHUqX@myon.chronox.de>
References: <2396177.vxvG2ljJL8@myon.chronox.de> <3972168.arX3qfUzsN@myon.chronox.de> <1397240421.7113.39.camel@joe-AO722>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	aquini@redhat.com, jeremy.wayne.powell@gmail.com,
	clemens@ladisch.de, pwalten@au1.ibm.com
To: Joe Perches <joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1397240421.7113.39.camel@joe-AO722>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Freitag, 11. April 2014, 11:20:21 schrieb Joe Perches:

Hi Joe,

> 
> It looks like const could be used a bit more often.
> 
> For instance:
> perhaps uses of key could be changed to const unsigned char *key
 
Good point. I will try to find areas where const can be used. However, due to 
the use of a linked list approach with struct drbg_string, using const will 
remain limited.

Ciao
Stephan
-- 
| Cui bono? |
