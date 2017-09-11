From: Srishti Sharma <srishtishar@gmail.com>
Subject: Re: [PATCH v2] Staging: ccree: Prefer using BIT macro.
Date: Mon, 11 Sep 2017 22:47:57 +0530
Message-ID: <CAB3L5oysec19U1WBAJrSb_qck7kJ_p9gj=wae-0w3y-pDDoDVw@mail.gmail.com>
References: <1504793692-8996-1-git-send-email-srishtishar@gmail.com>
 <20170911162458.GA24025@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, outreachy-kernel@googlegroups.com,
 driverdev-devel@linuxdriverproject.org,
 Linux kernel mailing list <linux-kernel@vger.kernel.org>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20170911162458.GA24025@kroah.com>
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

On Mon, Sep 11, 2017 at 9:54 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Thu, Sep 07, 2017 at 07:44:52PM +0530, Srishti Sharma wrote:
>> Use BIT(x) instead of using (1<<x), reported by checkpatch.pl.
>>
>> Signed-off-by: Srishti Sharma <srishtishar@gmail.com>
>> ---
>> Changes in v2:
>>  - Add tab spaces before BIT macro.
>>
>>  drivers/staging/ccree/ssi_cipher.h | 10 +++++-----
>>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> This change is already in my tree from someone else, sorry.
Oh.. It's okay !

Thanks,
Srishti
>
> greg k-h
