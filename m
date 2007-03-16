From: Chinh Nguyen <cnguyen@certicom.com>
Subject: SHA-2 HMAC support in linux kernel
Date: Fri, 16 Mar 2007 16:51:40 -0500
Message-ID: <45FB116C.5080205@certicom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.ca.certicom.com ([38.113.160.197]:47421 "EHLO
	mail.ca.certicom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965931AbXCPVLV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 16 Mar 2007 17:11:21 -0400
Received: from spamfilter.certicom.com (localhost.localdomain [127.0.0.1])
	by mail.ca.certicom.com (Postfix) with ESMTP id BFAA812B40180
	for <linux-crypto@vger.kernel.org>; Fri, 16 Mar 2007 15:51:50 -0500 (EST)
Received: from mail.ca.certicom.com ([127.0.0.1])
	by spamfilter.certicom.com (storm [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 10431-46 for <linux-crypto@vger.kernel.org>;
	Fri, 16 Mar 2007 15:51:44 -0500 (EST)
Received: from domino1.certicom.com (domino1.certicom.com [10.0.1.24])
	by mail.ca.certicom.com (Postfix) with ESMTP id C9E3C12B40189
	for <linux-crypto@vger.kernel.org>; Fri, 16 Mar 2007 15:51:44 -0500 (EST)
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

I believe that this is the right list for my question. I'm trying to get 
SHA-2 HMAC support working ipsec in linux kernel (I'm configuring via 
pfkey).

First, sha-384 and sha-512 as authentication algorithm always return 
function not support. But I noted that my linux kernel has a sha512 
kernel module (with alias for sha384). Second, sha-256 uses a 12-byte 
hmac (96 bits).

Looking at the source http://lxr.linux.no/source/net/xfrm/xfrm_algo.c, 
it seems to confirm that this is true. In fact, sha-384 and sha-512 are 
not supported at this time and sha-256 is truncated to 96-bit.

However, the following ietf draft, which I believe is very closed to 
ratification (it has already been assigned iana numbers), specifies 
sha-256 to use 128-bits as hmac (page 18): 
http://www.ietf.org/internet-drafts/draft-kelly-ipsec-ciph-sha2-01.txt

sha-384 is 192 bits, and sha-512 is 256 bits.

1. Is adding sha-384 and sha-512 as simple as adding to the aalg_list 
structure? Can this be done for some subsequent kernel release in the 
future?
2. Can the sha-256 be changed to use 128 bits? Or in order to not break 
backward compatibility, another sha-256 hmac algorithm id be used for 
128 bits?

Thanks,

Chinh
