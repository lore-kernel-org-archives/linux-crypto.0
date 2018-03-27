From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [dm-devel] [PATCH 2/2] md: dm-verity: allow parallel processing
 of bio blocks
Date: Tue, 27 Mar 2018 10:05:14 +0200
Message-ID: <24539e45-a018-f1e9-feb0-ea7a315e8284@gmail.com>
References: <1522003290-27243-1-git-send-email-yael.chemla@foss.arm.com>
 <1522003290-27243-2-git-send-email-yael.chemla@foss.arm.com>
 <20180327065519.GA745@sol.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, ofir.drang@gmail.com,
        Yael Chemla <yael.chemla@arm.com>,
        linux-crypto@vger.kernel.org, gilad@benyossef.com
To: Eric Biggers <ebiggers3@gmail.com>,
        Yael Chemla <yael.chemla@foss.arm.com>,
        Mike Snitzer <snitzer@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180327065519.GA745@sol.localdomain>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Mike and others,

did anyone even try to run veritysetup tests?

We have verity-compat-test in our testsuite, is has even basic FEC tests included.

We just added userspace verification of FEC RS codes to compare if kernel behaves the same.

I tried to apply three last dm-verity patches from your tree to Linus mainline.

It does even pass the *first* line of the test script and blocks the kernel forever...
(Running on 32bit Intel VM.)

*NACK* to the last two dm-verity patches.

(The "validate hashes once" is ok, despite I really do not like this approach...)

And comments from Eric are very valid as well, I think all this need to be fixed
before it can go to mainline.

Thanks,
Milan

On 03/27/2018 08:55 AM, Eric Biggers wrote:
> [+Cc linux-crypto]
> 
> Hi Yael,
> 
> On Sun, Mar 25, 2018 at 07:41:30PM +0100, Yael Chemla wrote:
>>  Allow parallel processing of bio blocks by moving to async. completion
>>  handling. This allows for better resource utilization of both HW and
>>  software based hash tfm and therefore better performance in many cases,
>>  depending on the specific tfm in use.
>>  
>>  Tested on ARM32 (zynq board) and ARM64 (Juno board).
>>  Time of cat command was measured on a filesystem with various file sizes.
>>  12% performance improvement when HW based hash was used (ccree driver).
>>  SW based hash showed less than 1% improvement.
>>  CPU utilization when HW based hash was used presented 10% less context
>>  switch, 4% less cycles and 7% less instructions. No difference in
>>  CPU utilization noticed with SW based hash.
>>  
>> Signed-off-by: Yael Chemla <yael.chemla@foss.arm.com>
> 
> Okay, I definitely would like to see dm-verity better support hardware crypto
> accelerators, but these patches were painful to read.
> 
> There are lots of smaller bugs, but the high-level problem which you need to
> address first is that on every bio you are always allocating all the extra
> memory to hold a hash request and scatterlist for every data block.  This will
> not only hurt performance when the hashing is done in software (I'm skeptical
> that your performance numbers are representative of that case), but it will also
> fall apart under memory pressure.  We are trying to get low-end Android devices
> to start using dm-verity, and such devices often have only 1 GB or even only 512
> MB of RAM, so memory allocations are at increased risk of failing.  In fact I'm
> pretty sure you didn't do any proper stress testing of these patches, since the
> first thing they do for every bio is try to allocate a physically contiguous
> array that is nearly as long as the full bio data itself (n_blocks *
> sizeof(struct dm_verity_req_data) = n_blocks * 3264, at least on a 64-bit
> platform, mostly due to the 'struct dm_verity_fec_io'), so potentially up to
> about 1 MB; that's going to fail a lot even on systems with gigabytes of RAM...
> 
> (You also need to verify that your new code is compatible with the forward error
> correction feature, with the "ignore_zero_blocks" option, and with the new
> "check_at_most_once" option.  From my reading of the code, all of those seemed
> broken; the dm_verity_fec_io structures, for example, weren't even being
> initialized...)
> 
> I think you need to take a close look at how dm-crypt handles async crypto
> implementations, since it seems to do it properly without hurting the common
> case where the crypto happens synchronously.  What it does, is it reserves space
> in the per-bio data for a single cipher request.  Then, *only* if the cipher
> implementation actually processes the request asynchronously (as indicated by
> -EINPROGRESS being returned) is a new cipher request allocated dynamically,
> using a mempool (not kmalloc, which is prone to fail).  Note that unlike your
> patches it also properly handles the case where the hardware crypto queue is
> full, as indicated by the cipher implementation returning -EBUSY; in that case,
> dm-crypt waits to start another request until there is space in the queue.
> 
> I think it would be possible to adapt dm-crypt's solution to dm-verity.
> 
> Thanks,
> 
> Eric
