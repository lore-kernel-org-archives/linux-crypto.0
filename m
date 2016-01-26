From: Sasha Levin <sasha.levin@oracle.com>
Subject: Re: crypto: algif_hash: creating 0 sized array in hash_accept
Date: Tue, 26 Jan 2016 09:30:54 -0500
Message-ID: <56A7831E.5020208@oracle.com>
References: <56A6119C.1080203@oracle.com>
 <20160125135846.GB8256@gondor.apana.org.au> <56A77411.5030209@oracle.com>
 <20160126140724.GA22685@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	"open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29243 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965937AbcAZObH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jan 2016 09:31:07 -0500
In-Reply-To: <20160126140724.GA22685@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/26/2016 09:07 AM, Herbert Xu wrote:
> On Tue, Jan 26, 2016 at 08:26:41AM -0500, Sasha Levin wrote:
>> >
>> > This seems to be happening with "digest_null".
> In that case this is expected as digest_null obviously has no
> state.  So why is a zero-length array disallowed by ubsan?

The C spec forbids it, so ubsan complains :)


Thanks,
Sasha
