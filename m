From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [Patch V2] crypto: x86/sha1 : Fix reads beyond the number of
 blocks passed
Date: Wed, 2 Aug 2017 09:05:11 -0700
Message-ID: <78e1ae83-8d30-2824-3772-b01f5c79b6a0@linux.intel.com>
References: <1501634312-22788-1-git-send-email-megha.dey@linux.intel.com>
 <902d020b-5127-8611-9656-bf0062d1e09b@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, ilya.albrekht@intel.com,
        megha.dey@intel.com
To: Jan Stancek <jstancek@redhat.com>,
        Megha Dey <megha.dey@linux.intel.com>,
        herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <902d020b-5127-8611-9656-bf0062d1e09b@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 08/02/2017 03:39 AM, Jan Stancek wrote:
> On 08/02/2017 02:38 AM, Megha Dey wrote:
>> It was reported that the sha1 AVX2 function(sha1_transform_avx2) is
>> reading ahead beyond its intended data, and causing a crash if the next
>> block is beyond page boundary:
>> http://marc.info/?l=linux-crypto-vger&m=149373371023377
>>
>> This patch makes sure that there is no overflow for any buffer length.
>>
>> It passes the tests written by Jan Stancek that revealed this problem:
>> https://github.com/jstancek/sha1-avx2-crash
>>
>> Jan, can you verify this fix?
> 
> Hi,
> 
> Looks good, my tests (below) PASS-ed.
> 
> I updated reproducer at [1] to try more than just single scenario. It
> now tries thousands of combinations with different starting offset within
> page and sizes of data chunks.
> 
> (without patch) v4.13-rc3-102-g26c5ceb with avx2 enabled:
> [  106.455175] sha_test module loaded
> [  106.460458] data is at 0xffff8c88e58f8000, page_after_data: 0xffff8c88e58fa000
> [  106.468625] sha_test testing hash: sha1-generic, maxlen: 8192
> [  127.091237] sha_test hash: sha1-generic calculated 1764032 hashes
> [  127.098038] sha_test testing hash: sha1-ni, maxlen: 8192
> [  127.108805] failed to alloc sha1-ni
> [  127.112703] sha_test testing hash: sha1-avx, maxlen: 8192
> [  141.166611] sha_test hash: sha1-avx calculated 1764032 hashes
> [  141.173023] sha_test testing hash: sha1-avx2, maxlen: 8192
> [  141.180046] BUG: unable to handle kernel paging request at ffff8c88e58fa000
> [  141.187817] IP: _begin+0x28/0x187
> [  141.191512] PGD 89c578067
> [  141.191513] P4D 89c578067
> [  141.194529] PUD c61f0a063
> [  141.197545] PMD c64cb1063
> [  141.200561] PTE 8000000c658fa062
> [  141.203577]
> [  141.208832] Oops: 0000 [#1] SMP
> ...
> 
> With patch "[Patch V2] crypto: x86/sha1 : Fix reads beyond the number of blocks passed":
> [  406.323781] sha_test module loaded
> [  406.329062] data is at 0xffff93ab97108000, page_after_data: 0xffff93ab9710a000
> [  406.337185] sha_test testing hash: sha1-generic, maxlen: 8192
> [  426.157242] sha_test hash: sha1-generic calculated 1764032 hashes
> [  426.164043] sha_test testing hash: sha1-ni, maxlen: 8192
> [  426.174244] failed to alloc sha1-ni
> [  426.178139] sha_test testing hash: sha1-avx, maxlen: 8192
> [  440.226240] sha_test hash: sha1-avx calculated 1764032 hashes
> [  440.232651] sha_test testing hash: sha1-avx2, maxlen: 8192
> [  452.497988] sha_test hash: sha1-avx2 calculated 1764032 hashes
> [  452.504495] sha_test testing hash: sha1-ssse3, maxlen: 8192
> [  467.319316] sha_test hash: sha1-ssse3 calculated 1764032 hashes
> [  467.325922] sha_test done
> [  471.827083] sha_test module unloaded
> 
> I also ran a test at [2], which is comparing hashes produced by
> kernel with hashes produced by user-space utilities (e.g. 'sha1sum').
> This test also PASS-ed.

Great.  Should the fix be picked up also in the stable branches since
it was disabled in the stable releases?  Or the changes are too
much for stable?

Tim
