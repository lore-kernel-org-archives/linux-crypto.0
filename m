From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: Limited usefulness of RSA set key function
Date: Mon, 03 Aug 2015 11:32:41 -0700
Message-ID: <55BFB3C9.7060407@intel.com>
References: <BC087D1C-7D4D-4F6D-9644-B2043C3E39D3@holtmann.org> <3848823.PNN01JLIZu@tauon.atsec.com> <6876D9AA-A51A-4D79-9127-3B3ED58784CA@holtmann.org> <1580424.u6GEQiXd8T@myon.chronox.de> <2726A091-A7A2-451F-BB11-A19A73DA3C36@holtmann.org> <55BFA0B5.6070107@intel.com> <6C3A9837-2B02-4133-B916-40F0F1BAF51B@holtmann.org> <55BFAA5C.6010101@intel.com> <C0C27417-4970-48AF-A115-0C83DC000EBE@holtmann.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: David Howells <dhowells@redhat.com>,
	Stephan Mueller <smueller@chronox.de>,
	linux-crypto@vger.kernel.org
To: Marcel Holtmann <marcel@holtmann.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:36870 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753826AbbHCSdu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Aug 2015 14:33:50 -0400
In-Reply-To: <C0C27417-4970-48AF-A115-0C83DC000EBE@holtmann.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 08/03/2015 11:20 AM, Marcel Holtmann wrote:
> actually I think this reasoning needs to be revisited. When I look at this, this makes no sense whatsoever. The end result is that we have keys in multiple formats in the kernel and have to convert between them or parse them again.
> 
> If you do not want to use struct public_key, then lets go for struct key as I proposed in my other response. That should in the end be able to represent hardware keys as well. There is really no good reason to move things around and parse them again or create new formats out of it.
> 
> My take is that we want to store a key once in a single location and single location only. Storing the same key in different formats in different locations is just a plain bad idea. Keep it secure and locked in one place.
> 

The approach was not to use any of the existing public key stuff.
To be consistent with all the other crypto API tfm needs to "own" the key.
The existing struct key is not controlled by the tfm and the key can be gone without tfm knowing.
We can change this approach, but this is not my call, but Herbert's.
Herbert, any comments?

> I hope someone is looking at lib/digsig.c as well and gets this all cleaned up into a single implementation. However for this to happen, we really need to get this key stuff figured out. Right now this looks to me like the left hand does not know what the right hand is doing.

Yes, your are right, but crypto/public_key/rsa.c and lib/digsig.c have been added long before akcipher.
Now we are trying to get all this fixed, but we need to have stable API before any of it will be converted.
Thanks,
T
 
