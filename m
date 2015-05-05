From: Milan Broz <mbroz@redhat.com>
Subject: Re: [PATCH 3.14 73/92] dm crypt: fix deadlock when async crypto algorithm
 returns -EBUSY
Date: Tue, 05 May 2015 08:42:44 +0200
Message-ID: <55486664.4000607@redhat.com>
References: <20150502190109.683061482@linuxfoundation.org> <20150502190117.069180534@linuxfoundation.org> <20150504213254.GA27445@debian> <20150505032213.GB4954@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ben Collins <ben.c@servergy.com>, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, dm-devel@redhat.com,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: Mike Snitzer <snitzer@redhat.com>, Rabin Vincent <rabin@rab.in>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20150505032213.GB4954@redhat.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 05/05/2015 05:22 AM, Mike Snitzer wrote:
> On Mon, May 04 2015 at  5:32pm -0400,
> Rabin Vincent <rabin@rab.in> wrote:
> 
>> On Sat, May 02, 2015 at 09:03:28PM +0200, Greg Kroah-Hartman wrote:
>>> 3.14-stable review patch.  If anyone has any objections, please let me know.
>>>
>>> ------------------
>>>
>>> From: Ben Collins <ben.c@servergy.com>
>>>
>>> commit 0618764cb25f6fa9fb31152995de42a8a0496475 upstream.
>>
>> The commit in question was recently merged to mainline and is now being
>> sent to various stable kernels.  But I think the patch is wrong and the
>> real problem lies in the Freescale CAAM driver which is described as
>> having being tested with.
...

>> dm-crypt uses CRYPTO_TFM_REQ_MAY_BACKLOG.  This means the the crypto
>> driver should internally backlog requests which arrive when the queue is
>> full and process them later.  Until the crypto hw's queue becomes full,
>> the driver returns -EINPROGRESS.  When the crypto hw's queue if full,
>> the driver returns -EBUSY, and if CRYPTO_TFM_REQ_MAY_BACKLOG is set, is
>> expected to backlog the request and process it when the hardware has
>> queue space.  At the point when the driver takes the request from the
>> backlog and starts processing it, it calls the completion function with
>> a status of -EINPROGRESS.  The completion function is called (for a
>> second time, in the case of backlogged requests) with a status/err of 0
>> when a request is done.


Mike, I thought there was a discussion with crypto API maintainer before
merging this patch, I think there were some comments that the patch seems
to be not correct...
This API (EBUSY/EINPROGESS codes) use was there since dmcrypt switched
to async crypto API.

There should tests for it (some years ago we tested the async path by forcing
to use cryptd, this was able to clearly simulate the BUSY path as well),
but not sure if it is still possible so easily.

> Any chance you'd be willing to provide in-code comments in the
> appropriate places in dm-crypt.c (after having reverted this patch in
> question)?
> 
> I'd be happy to take the combination of the revert and documentation in
> a single patch and get it to Linus for 4.0-rc3.

Please, do not mix revert patches with additions (even if it is just comment),
someone could be even more confused what's going on here.

If nobody volunteers, I'll try to add some comments later to dmcrypt code,
but that is definitely not for stable.

Thanks,
Milan
