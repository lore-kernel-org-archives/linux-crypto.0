From: bincy <bincy_k_philip@yahoo.co.in>
Subject: Re: [PATCH] Stagingdriver cctree: Fix for checkpatch warning
Date: Wed, 12 Jul 2017 14:23:56 +0530
Message-ID: <5e1bd391-3f79-f6d6-696a-cfd2ec9ea751@yahoo.co.in>
References: <1498797169-3093-1-git-send-email-bincy_k_philip@yahoo.co.in>
 <CAOtvUMf3CU7O6x8VpNzPLNtvmKhXC0eDCrueYTpkXErmHcg_hA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <CAOtvUMf3CU7O6x8VpNzPLNtvmKhXC0eDCrueYTpkXErmHcg_hA@mail.gmail.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

Hi Gilad,

I have added your comments and resent the patch.Thanks

On 11/07/17 17:16, Gilad Ben-Yossef wrote:
> Hello Philip,
>
> Thank your patch.
>
> Your patch subject line is not descriptive and not formatted well.
>
> A better subject would be something like:
>
> staging: ccree: move comment to fit coding style
>
> Thanks,
> Gilad
>
> On Fri, Jun 30, 2017 at 7:32 AM,  <bincy_k_philip@yahoo.co.in> wrote:
>> From: Bincy K Philip <bincy_k_philip@yahoo.co.in>
>>
>> Trivial fix for Line over 80 characters
>>
>> Moved the comment to top of the definition
>>
>> Signed-off-by: Bincy K Philip <bincy_k_philip@yahoo.co.in>
>> ---
>>  drivers/staging/ccree/cc_hw_queue_defs.h | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/ccree/cc_hw_queue_defs.h b/drivers/staging/ccree/cc_hw_queue_defs.h
>> index aaa56c8..a18e6c9 100644
>> --- a/drivers/staging/ccree/cc_hw_queue_defs.h
>> +++ b/drivers/staging/ccree/cc_hw_queue_defs.h
>> @@ -27,7 +27,8 @@
>>  ******************************************************************************/
>>
>>  #define HW_DESC_SIZE_WORDS             6
>> -#define HW_QUEUE_SLOTS_MAX              15 /* Max. available slots in HW queue */
>> +/* Define max. available slots in HW queue */
>> +#define HW_QUEUE_SLOTS_MAX              15
>>
>>  #define CC_REG_NAME(word, name) DX_DSCRPTR_QUEUE_WORD ## word ## _ ## name
>>
>> --
>> 1.8.3.1
>>
>
>
>
