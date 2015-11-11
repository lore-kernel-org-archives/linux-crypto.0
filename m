From: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH 4/4] crypto: RSA padding algorithm
Date: Wed, 11 Nov 2015 22:25:29 +0900
Message-ID: <6C8201C5-35DF-4DDE-A056-FF54E2A12D66@holtmann.org>
References: <1447203525-16796-1-git-send-email-andrew.zaborowski@intel.com> <1447203525-16796-4-git-send-email-andrew.zaborowski@intel.com> <1592431.XvasPcx0bt@tauon.atsec.com>
Mime-Version: 1.0 (Mac OS X Mail 9.1 \(3096.5\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Andrew Zaborowski <andrew.zaborowski@intel.com>,
	linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [82.165.8.211] ([82.165.8.211]:39721 "EHLO mail.holtmann.org"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752254AbbKKNa4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Nov 2015 08:30:56 -0500
In-Reply-To: <1592431.XvasPcx0bt@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

>> This patch adds PKCS#1 v1.5 standard RSA padding as a separate template.
>> This way an RSA cipher with padding can be obtained by instantiating
>> "pkcs1pad(rsa)".  The reason for adding this is that RSA is almost
>> never used without this padding (or OAEP) so it will be needed for
>> either certificate work in the kernel or the userspace, and also I hear
>> that it is likely implemented by hardware RSA in which case an
>> implementation of the whole "pkcs1pad(rsa)" can be provided.
> 
> In general, I think that there is a PKCS 1 implementation in the kernel in 
> crypto/asymmetric_keys/rsa.c
> 
> Shouldn't that all somehow being synchronized?
> 
> Maybe this patch should go in but then crypto/asymmetric_keys/rsa.c should 
> kind of being removed or point to kernel crypto API?

I think crypto/asymmetric_keys/ needs to move to security/keys/asymmetric/ and then utilize akcipher and also PKCS 1 from crypto/

Regards

Marcel
