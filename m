From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH 4/4] crypto: RSA padding algorithm
Date: Wed, 11 Nov 2015 13:58:27 -0800
Message-ID: <5643BA03.20606@intel.com>
References: <1447203525-16796-1-git-send-email-andrew.zaborowski@intel.com>
 <1447203525-16796-4-git-send-email-andrew.zaborowski@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: Andrew Zaborowski <andrew.zaborowski@intel.com>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:59698 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbbKKWBh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Nov 2015 17:01:37 -0500
In-Reply-To: <1447203525-16796-4-git-send-email-andrew.zaborowski@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 11/10/2015 04:58 PM, Andrew Zaborowski wrote:
> This patch adds PKCS#1 v1.5 standard RSA padding as a separate template.
> This way an RSA cipher with padding can be obtained by instantiating
> "pkcs1pad(rsa)".  The reason for adding this is that RSA is almost
> never used without this padding (or OAEP) so it will be needed for
> either certificate work in the kernel or the userspace, and also I hear
> that it is likely implemented by hardware RSA in which case an
> implementation of the whole "pkcs1pad(rsa)" can be provided.
> 
> Signed-off-by: Andrew Zaborowski <andrew.zaborowski@intel.com>
> ---
>  crypto/Makefile               |   1 +
>  crypto/rsa-padding.c          | 586 ++++++++++++++++++++++++++++++++++++++++++
>  crypto/rsa.c                  |  16 +-
>  include/crypto/internal/rsa.h |   2 +
>  4 files changed, 604 insertions(+), 1 deletion(-)
>  create mode 100644 crypto/rsa-padding.c

Can we call this new file rsa-pkcs1pad.c instead?
Thanks
