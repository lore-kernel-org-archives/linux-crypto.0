From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Subject: Re: [PATCH v4 0/5] /dev/random - a new approach
Date: Tue, 21 Jun 2016 13:54:13 -0400
Message-ID: <9a0a80fb-779e-b708-990e-1627ec03b1b7@gmail.com>
References: <1466007463.20087.11.camel@redhat.com>
 <1466515196.17017.8.camel@redhat.com>
 <e70c9e01-5e48-a26a-d485-ca512c111cbc@gmail.com>
 <6038462.HIH9pGNYO7@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Tomas Mraz <tmraz@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
	=?UTF-8?Q?David_Ja=c5=a1a?= <djasa@redhat.com>,
	Andi Kleen <andi@firstfloor.org>, sandyinchina@gmail.com,
	Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Joe Perches <joe@perches.com>, Pavel Machek <pavel@ucw.cz>,
	George Spelvin <linux@horizon.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:33937 "EHLO
	mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbcFURyU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Jun 2016 13:54:20 -0400
In-Reply-To: <6038462.HIH9pGNYO7@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 2016-06-21 13:23, Stephan Mueller wrote:
> Am Dienstag, 21. Juni 2016, 13:18:33 schrieb Austin S. Hemmelgarn:
>
> Hi Austin,
>
>>> You have to trust the host for anything, not just for the entropy in
>>> timings. This is completely invalid argument unless you can present a
>>> method that one guest can manipulate timings in other guest in such a
>>> way that _removes_ the inherent entropy from the host.
>>
>> When dealing with almost any type 2 hypervisor, it is fully possible for
>> a user other than the one running the hypervisor to manipulate
>> scheduling such that entropy is reduced.  This does not imply that the
>
> Please re-read the document: Jitter RNG does not rest on scheduling.
If you are running inside a VM, your interrupt timings depend on the 
hpyervisor's scheduling, period.  You may not directly rely on 
scheduling from the OS you are running on, but if you are doing anything 
timing related in a VM, you are at the mercy of the scheduling used by 
the hypervisor and whatever host OS that may be running on.

In the attack I"m describing, the malicious user is not manipulating the 
guest OS's scheduling, they are manipulating the host system's scheduling.
