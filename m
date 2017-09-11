From: Srishti Sharma <srishtishar@gmail.com>
Subject: Re: [PATCH] Staging: ccree: Don't use volatile for monitor_lock
Date: Mon, 11 Sep 2017 21:38:04 +0530
Message-ID: <CAB3L5oxcyhgyy8EuGuPo9QtJQd-W7JTgQQE1PfopZFmSx58P9g@mail.gmail.com>
References: <1505145571-11248-1-git-send-email-srishtishar@gmail.com>
 <20170911160449.GA11886@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, outreachy-kernel@googlegroups.com,
 driverdev-devel@linuxdriverproject.org,
 Linux kernel mailing list <linux-kernel@vger.kernel.org>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20170911160449.GA11886@kroah.com>
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

On Mon, Sep 11, 2017 at 9:34 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Mon, Sep 11, 2017 at 09:29:31PM +0530, Srishti Sharma wrote:
>> The use of volatile for the variable monitor_lock is unnecessary.
>>
>> Signed-off-by: Srishti Sharma <srishtishar@gmail.com>
>> ---
>>  drivers/staging/ccree/ssi_request_mgr.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
>> index e5c2f92..7d77941 100644
>> --- a/drivers/staging/ccree/ssi_request_mgr.c
>> +++ b/drivers/staging/ccree/ssi_request_mgr.c
>> @@ -49,7 +49,7 @@ struct ssi_request_mgr_handle {
>>       dma_addr_t dummy_comp_buff_dma;
>>       struct cc_hw_desc monitor_desc;
>>
>> -     volatile unsigned long monitor_lock;
>> +     unsigned long monitor_lock;
>
> While volatile is not right, odds are, this is still totally wrong as
> well.  How about using a "real" lock instead?

I tried to find where is this variable being used in the code, but I
didn't find any usage of it . It might be an important attribute of
this structure definition but, I don't see it's value being set to
anything or being used somewhere .

Regards,
Srishti
>
> thanks,
>
> greg k-h
