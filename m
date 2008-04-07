From: Joy Latten <latten@austin.ibm.com>
Subject: RE: Test AES-CCM mode via IPSec (NETKEY)
Date: Mon, 7 Apr 2008 16:13:48 -0500
Message-ID: <200804072113.m37LDmK7004386@faith.austin.ibm.com>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: lho@amcc.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:46877 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753445AbYDGV0v (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Apr 2008 17:26:51 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m37LSsHK025362
	for <linux-crypto@vger.kernel.org>; Mon, 7 Apr 2008 17:28:54 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m37LQoZb1075938
	for <linux-crypto@vger.kernel.org>; Mon, 7 Apr 2008 17:26:50 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m37LQnl2008289
	for <linux-crypto@vger.kernel.org>; Mon, 7 Apr 2008 17:26:50 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

>Hi,
>
>Try these scripts with proper IP address. In addition, you must patch
>iproute2 manually using the patch from Herbert's email:
>
>[lho@svdclab161 sec]$ cat ip-start-transport-ccm
>#!/bin/sh
>
>NODE=$1
>
>echo "Starting IPSec transport mode using CCM..."
>
>./ip xfrm policy flush
>./ip xfrm state flush
>#
># SA
>./ip xfrm state add src 10.66.21.164 dst 10.66.21.166 proto esp spi
>0x201 mode transport aead "rfc4309(ccm(aes))"
>0x0102037aeaca3f87d060a12f4a4487d5a5c335 96
>./ip xfrm state add src 10.66.21.166 dst 10.66.21.164 proto esp spi
>0x301 mode transport aead "rfc4309(ccm(aes))"
>0x010203f6ddb555acfd9d77b03ea3843f265325 96
>#
># Policy
>if [ "${NODE}" = "A" ]; then
>        ./ip xfrm policy add dir out src 10.66.21.164 dst 10.66.21.166
>tmpl proto esp mode transport
>        ./ip xfrm policy add dir in src 10.66.21.166 dst 10.66.21.164
>tmpl proto esp mode transport
>fi
>if [ "${NODE}" = "B" ]; then
>        ./ip xfrm policy add dir in src 10.66.21.164 dst 10.66.21.166
>tmpl proto esp mode transport
>        ./ip xfrm policy add dir out src 10.66.21.166 dst 10.66.21.164
>tmpl proto esp mode transport
>fi
> 
>[lho@svdclab161 sec]$ cat ip-start-transport-gcm
>#!/bin/sh
>
>NODE=$1
>
>echo "Starting IPSec transport mode using GCM..."
>
>./ip xfrm policy flush
>./ip xfrm state flush
>#
># SA
>./ip xfrm state add src 10.66.21.164 dst 10.66.21.166 proto esp spi
>0x201 mode transport aead "rfc4106(gcm(aes))"
>0x010203047aeaca3f87d060a12f4a4487d5a5c335 96
>./ip xfrm state add src 10.66.21.166 dst 10.66.21.164 proto esp spi
>0x301 mode transport aead "rfc4106(gcm(aes))"
>0x01020304f6ddb555acfd9d77b03ea3843f265325 96
>#
># Policy
>if [ "${NODE}" = "A" ]; then
>        ./ip xfrm policy add dir out src 10.66.21.164 dst 10.66.21.166
>tmpl proto esp mode transport
>        ./ip xfrm policy add dir in src 10.66.21.166 dst 10.66.21.164
>tmpl proto esp mode transport
>fi
>if [ "${NODE}" = "B" ]; then
>        ./ip xfrm policy add dir in src 10.66.21.164 dst 10.66.21.166
>tmpl proto esp mode transport
>        ./ip xfrm policy add dir out src 10.66.21.166 dst 10.66.21.164
>tmpl proto esp mode transport
>fi
>

Thank you!! Your instructions were perfect and I had it working
in no time.

regards,
Joy
