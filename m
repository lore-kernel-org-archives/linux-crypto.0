From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v4 0/4] crypto: lrw - Fixes and improvements
Date: Sun, 30 Sep 2018 21:00:22 +0200
Message-ID: <CAKv+Gu9cBRsNuSbjmLF9MjGh+_n33Ugw3BsnLzmWNnoW=Zw-DQ@mail.gmail.com>
References: <20180913085134.11694-1-omosnace@redhat.com>
	<20180921054534.7iqfb3omlowromhr@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Eric Biggers <ebiggers@kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	"open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
	<linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180921054534.7iqfb3omlowromhr@gondor.apana.org.au>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-crypto.vger.kernel.org

On 21 September 2018 at 07:45, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Thu, Sep 13, 2018 at 10:51:30AM +0200, Ondrej Mosnacek wrote:
>> This patchset contains a corner-case fix and several improvements  for
>> the LRW template.
>>
>> The first patch fixes an out-of-bounds array access (and subsequently
>> incorrect cipher output) when the LRW counter goes from all ones to all
>> zeros. This patch should be applied to the crypto-2.6 tree and also go
>> to stable.
>>
>> The second patch adds a test vector for lrw(aes) that covers the above
>> bug.
>>
>> The third patch is a small optimization of the LRW tweak computation.
>>
>> The fourth patch is a follow-up to a similar patch for XTS (it
>> simplifies away the use of dynamically allocated auxiliary buffer to
>> cache the computed tweak values):
>> https://patchwork.kernel.org/patch/10588775/
>>
>> Patches 2-4 should be applied only to cryptodev-2.6, but they all depend
>> on the first patch.
>>
>> Changes in v4:
>>   - applied various corrections/suggestions from Eric Biggers
>>   - added a fix for buggy behavior on counter wrap-around (+ test vector)
>>
>> v3: https://www.spinics.net/lists/linux-crypto/msg34946.html
>> Changes in v3:
>>   - fix a copy-paste error
>>
>> v2: https://www.spinics.net/lists/linux-crypto/msg34890.html
>> Changes in v2:
>>   - small cleanup suggested by Eric Biggers
>>
>> v1: https://www.spinics.net/lists/linux-crypto/msg34871.html
>>
>> Ondrej Mosnacek (4):
>>   crypto: lrw - Fix out-of bounds access on counter overflow
>>   crypto: testmgr - Add test for LRW counter wrap-around
>>   crypto: lrw - Optimize tweak computation
>>   crypto: lrw - Do not use auxiliary buffer
>>
>>  crypto/lrw.c     | 342 +++++++++++++----------------------------------
>>  crypto/testmgr.h |  21 +++
>>  2 files changed, 112 insertions(+), 251 deletions(-)
>
> All applied.  Thanks.

I am seeing tcrypt failures with this code:

alg: skcipher: Test 8 failed (invalid result) on encryption for lrw(ecb-aes-ce)
00000000: 47 90 50 f6 f4 8d 5c 7f 84 c7 83 95 2d a2 02 c0
00000010: da 7f a3 c0 88 2a 0a 50 fb c1 78 03 39 fe 1d e5
00000020: 47 90 50 f6 f4 8d 5c 7f 84 c7 83 95 2d a2 02 c0

reproduced on both arm64 and ARM (the latter in LE and BE modes)
