From: Milan Broz <mbroz@redhat.com>
Subject: Re: [PATCH] dm-crypt: disable block encryption with arc4
Date: Mon, 25 Jan 2010 19:39:11 +0100
Message-ID: <4B5DE54F.7050206@redhat.com>
References: <Pine.LNX.4.64.1001251324310.18309@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>,
	linux-crypto@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940Ab0AYSjT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Jan 2010 13:39:19 -0500
Received: from int-mx08.intmail.prod.int.phx2.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o0PIdIaW032444
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-crypto@vger.kernel.org>; Mon, 25 Jan 2010 13:39:18 -0500
In-Reply-To: <Pine.LNX.4.64.1001251324310.18309@hs20-bc2-1.build.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/25/2010 07:29 PM, Mikulas Patocka wrote:
> Hi
> 
> When using arc4 to encrypt a block device, the resulting device is 
> unreliable. It reads garbage. That's because arc4 is a stream cipher, if 
> you write something, it advances its state and if you attempt to decrypt 
> the same sector, it uses new state that is different.
> 
> This patch disables the use of arc4 on block devices.

arc4 again. it is simply not a block cipher:-)

This should be solved inside cryptoAPI and not blacklist it in dm-crypt,
see that thread
http://article.gmane.org/gmane.linux.kernel.cryptoapi/3441

Milan
