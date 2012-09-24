From: Milan Broz <mbroz@redhat.com>
Subject: Re: [PATCH 0/1] dm-integrity: integrity protection device-mapper
 target
Date: Mon, 24 Sep 2012 15:47:02 +0200
Message-ID: <50606456.7020607@redhat.com>
References: <cover.1348480396.git.dmitry.kasatkin@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, dm-devel@redhat.com,
	linux-crypto@vger.kernel.org
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754136Ab2IXNrL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Sep 2012 09:47:11 -0400
In-Reply-To: <cover.1348480396.git.dmitry.kasatkin@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09/24/2012 11:55 AM, Dmitry Kasatkin wrote:
> Both dm-verity and dm-crypt provide block level integrity protection.

This is not correct. dm-crypt is transparent block encryption target,
where always size of plaintext == size of ciphertext.

So it can provide confidentiality but it CANNOT provide integrity protection.

We need extra space to store auth tag which dmcrypt cannot provide currently.

> dm-integrity provides a lighter weight read-write block level integrity
> protection for file systems not requiring full disk encryption, but
> which do require writability.

Obvious question: can be dm-verity extended to provide read-write integrity?

I would prefer to use standard mode like GCM to provide both encryption and
integrity protection than inventing something new.

Milan
