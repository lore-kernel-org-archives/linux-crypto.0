From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Subject: Re: [PATCH v4 0/5] /dev/random - a new approach
Date: Tue, 21 Jun 2016 13:18:33 -0400
Message-ID: <e70c9e01-5e48-a26a-d485-ca512c111cbc@gmail.com>
References: <1466007463.20087.11.camel@redhat.com>
 <3381856.qSaz1KcX2Z@positron.chronox.de>
 <f22f4cd6-8198-71a0-9b79-9f10070758f3@gmail.com>
 <8999970.pstTbGZv5G@positron.chronox.de>
 <6b8c8f6a-862a-3e7c-e950-75cd93cdc1f7@gmail.com>
 <1466515196.17017.8.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Ts'o <tytso@mit.edu>,
	=?UTF-8?Q?David_Ja=c5=a1a?= <djasa@redhat.com>,
	Andi Kleen <andi@firstfloor.org>, sandyinchina@gmail.com,
	Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Joe Perches <joe@perches.com>, Pavel Machek <pavel@ucw.cz>,
	George Spelvin <linux@horizon.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Tomas Mraz <tmraz@redhat.com>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:38288 "EHLO
	mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbcFUSYN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Jun 2016 14:24:13 -0400
In-Reply-To: <1466515196.17017.8.camel@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 2016-06-21 09:19, Tomas Mraz wrote:
> On =C3=9At, 2016-06-21 at 09:05 -0400, Austin S. Hemmelgarn wrote:
>> On 2016-06-20 14:32, Stephan Mueller wrote:
>>>
>>> [1] http://www.chronox.de/jent/doc/CPU-Jitter-NPTRNG.pdf
>> Specific things I notice about this:
>> 1. QEMU systems are reporting higher values than almost anything
>> else
>> with the same ISA.  This makes sense, but you don't appear to have
>> accounted for the fact that you can't trust almost any of the entrop=
y
>> in
>> a VM unless you have absolute trust in the host system, because the
>> host
>> system can do whatever the hell it wants to you, including
>> manipulating
>> timings directly (with a little patience and some time spent working
>> on
>> it, you could probably get those number to show whatever you want
>> just
>> by manipulating scheduling parameters on the host OS for the VM
>> software).
>
> You have to trust the host for anything, not just for the entropy in
> timings. This is completely invalid argument unless you can present a
> method that one guest can manipulate timings in other guest in such a
> way that _removes_ the inherent entropy from the host.
When dealing with almost any type 2 hypervisor, it is fully possible fo=
r=20
a user other than the one running the hypervisor to manipulate=20
scheduling such that entropy is reduced.  This does not imply that the=20
user who is doing this has any other control over the target VM, and=20
importantly, often does not require administrative access on the host,=20
only regular user access.  Such an attack is very difficult to effect=20
outside of a clean-room environment, but is still possible.  You can't=20
use this to force generation of arbitrary data, but you can definitely=20
starve a VM for entropy.  By nature, something that relies on interrupt=
=20
timings will be more impacted by such an attack than something that doe=
s=20
not.

In most cases, such an attack will be a DoS attack on the host as well=20
(as that's the simplest way to do this).  This is less of an issue with=
=20
proper practices on a type 1 hypervisor, but is still possible there to=
o=20
(although pulling this off on at least Xen when you have proper VCPU=20
isolation is functionally impossible without administrative access to=20
the control domain).
