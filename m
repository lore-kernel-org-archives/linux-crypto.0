From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] crypto/pkcs7_verify: Fix unaligned access in pkcs7_verify()
Date: Thu, 15 Oct 2015 16:16:04 +0100
Message-ID: <20287.1444922164@warthog.procyon.org.uk>
References: <20151013145401.GM20800@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, marcel@holtmann.org, David.Woodhouse@intel.com
To: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35603 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255AbbJOPQK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 Oct 2015 11:16:10 -0400
In-Reply-To: <20151013145401.GM20800@oracle.com>
Content-ID: <20286.1444922164.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Sowmini Varadhan <sowmini.varadhan@oracle.com> wrote:

> On sparc, we see unaligned access messages on each modprobe[-r]:
> 
> Kernel unaligned access at TPC[6ad9b4] pkcs7_verify [..]
> Kernel unaligned access at TPC[6a5484] crypto_shash_finup [..]
> Kernel unaligned access at TPC[6a5390] crypto_shash_update [..]
> Kernel unaligned access at TPC[10150308] sha1_sparc64_update [..]
> Kernel unaligned access at TPC[101501ac] __sha1_sparc64_update [..]
> 
> These ware triggered by mod_verify_sig() invocations of pkcs_verify(), and
> are are being caused by an unaligned desc at (sha1, digest_size is 0x14)
>         desc = digest + digest_size;
> 
> To fix this, pkcs7_verify needs to make sure that desc is pointing
> at an aligned value past the digest_size, and kzalloc appropriately,
> taking alignment values into consideration.
> 
> Signed-off-by: Sowmini Varadhan <sowmini.varadhan@oracle.com>

Acked-by: David Howells <dhowells@redhat.com>
