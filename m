From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH v3 24/27] staging: ccree: use a consistent file naming
 convention
Date: Tue, 9 Jan 2018 09:42:22 +0200
Message-ID: <CAOtvUMe8JW6fDkJakX5ypz1Ha=M7CBW76UGRj6yAa1Zg9ecW1w@mail.gmail.com>
References: <1515327285-8948-1-git-send-email-gilad@benyossef.com>
 <1515327285-8948-25-git-send-email-gilad@benyossef.com>
 <20180108152818.GA7701@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 Ofir Drang <ofir.drang@arm.com>,
 Linux kernel mailing list <linux-kernel@vger.kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20180108152818.GA7701@kroah.com>
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

On Mon, Jan 8, 2018 at 5:28 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Sun, Jan 07, 2018 at 12:14:35PM +0000, Gilad Ben-Yossef wrote:
>> The ccree driver source files were using an inconsistent
>> naming convention stemming from what the company was called
>> when they were added.
>>
>> Move to a single consistent naming convention for better
>> code readability.
>>
>> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
>> ---
>>  drivers/staging/ccree/Makefile           |    6 +-
>>  drivers/staging/ccree/cc_aead.c          | 2709 ++++++++++++++++++++++++++++++
>>  drivers/staging/ccree/cc_aead.h          |  109 ++
>>  drivers/staging/ccree/cc_buffer_mgr.c    | 1657 ++++++++++++++++++
>>  drivers/staging/ccree/cc_buffer_mgr.h    |   74 +
>>  drivers/staging/ccree/cc_cipher.c        | 1171 +++++++++++++
>>  drivers/staging/ccree/cc_cipher.h        |   74 +
>>  drivers/staging/ccree/cc_debugfs.c       |    2 +-
>>  drivers/staging/ccree/cc_driver.c        |  508 ++++++
>>  drivers/staging/ccree/cc_driver.h        |  194 +++
>>  drivers/staging/ccree/cc_fips.c          |  112 ++
>>  drivers/staging/ccree/cc_fips.h          |   37 +
>>  drivers/staging/ccree/cc_hash.c          | 2299 +++++++++++++++++++++++++
>>  drivers/staging/ccree/cc_hash.h          |  114 ++
>>  drivers/staging/ccree/cc_host_regs.h     |  142 ++
>>  drivers/staging/ccree/cc_hw_queue_defs.h |    2 +-
>>  drivers/staging/ccree/cc_ivgen.c         |  281 ++++
>>  drivers/staging/ccree/cc_ivgen.h         |   55 +
>>  drivers/staging/ccree/cc_kernel_regs.h   |  167 ++
>>  drivers/staging/ccree/cc_pm.c            |  125 ++
>>  drivers/staging/ccree/cc_pm.h            |   57 +
>>  drivers/staging/ccree/cc_request_mgr.c   |  719 ++++++++
>>  drivers/staging/ccree/cc_request_mgr.h   |   51 +
>>  drivers/staging/ccree/cc_sram_mgr.c      |  107 ++
>>  drivers/staging/ccree/cc_sram_mgr.h      |   65 +
>>  drivers/staging/ccree/dx_crys_kernel.h   |  167 --
>>  drivers/staging/ccree/dx_host.h          |  142 --
>>  drivers/staging/ccree/ssi_aead.c         | 2709 ------------------------------
>>  drivers/staging/ccree/ssi_aead.h         |  109 --
>>  drivers/staging/ccree/ssi_buffer_mgr.c   | 1657 ------------------
>>  drivers/staging/ccree/ssi_buffer_mgr.h   |   74 -
>>  drivers/staging/ccree/ssi_cipher.c       | 1171 -------------
>>  drivers/staging/ccree/ssi_cipher.h       |   74 -
>>  drivers/staging/ccree/ssi_driver.c       |  508 ------
>>  drivers/staging/ccree/ssi_driver.h       |  194 ---
>>  drivers/staging/ccree/ssi_fips.c         |  112 --
>>  drivers/staging/ccree/ssi_fips.h         |   37 -
>>  drivers/staging/ccree/ssi_hash.c         | 2299 -------------------------
>>  drivers/staging/ccree/ssi_hash.h         |  114 --
>>  drivers/staging/ccree/ssi_ivgen.c        |  281 ----
>>  drivers/staging/ccree/ssi_ivgen.h        |   55 -
>>  drivers/staging/ccree/ssi_pm.c           |  125 --
>>  drivers/staging/ccree/ssi_pm.h           |   57 -
>>  drivers/staging/ccree/ssi_request_mgr.c  |  719 --------
>>  drivers/staging/ccree/ssi_request_mgr.h  |   51 -
>>  drivers/staging/ccree/ssi_sram_mgr.c     |  107 --
>>  drivers/staging/ccree/ssi_sram_mgr.h     |   65 -
>>  47 files changed, 10832 insertions(+), 10832 deletions(-)
>>  create mode 100644 drivers/staging/ccree/cc_aead.c
>>  create mode 100644 drivers/staging/ccree/cc_aead.h
>>  create mode 100644 drivers/staging/ccree/cc_buffer_mgr.c
>>  create mode 100644 drivers/staging/ccree/cc_buffer_mgr.h
>>  create mode 100644 drivers/staging/ccree/cc_cipher.c
>>  create mode 100644 drivers/staging/ccree/cc_cipher.h
>>  create mode 100644 drivers/staging/ccree/cc_driver.c
>>  create mode 100644 drivers/staging/ccree/cc_driver.h
>>  create mode 100644 drivers/staging/ccree/cc_fips.c
>>  create mode 100644 drivers/staging/ccree/cc_fips.h
>>  create mode 100644 drivers/staging/ccree/cc_hash.c
>>  create mode 100644 drivers/staging/ccree/cc_hash.h
>>  create mode 100644 drivers/staging/ccree/cc_host_regs.h
>>  create mode 100644 drivers/staging/ccree/cc_ivgen.c
>>  create mode 100644 drivers/staging/ccree/cc_ivgen.h
>>  create mode 100644 drivers/staging/ccree/cc_kernel_regs.h
>>  create mode 100644 drivers/staging/ccree/cc_pm.c
>>  create mode 100644 drivers/staging/ccree/cc_pm.h
>>  create mode 100644 drivers/staging/ccree/cc_request_mgr.c
>>  create mode 100644 drivers/staging/ccree/cc_request_mgr.h
>>  create mode 100644 drivers/staging/ccree/cc_sram_mgr.c
>>  create mode 100644 drivers/staging/ccree/cc_sram_mgr.h
>>  delete mode 100644 drivers/staging/ccree/dx_crys_kernel.h
>>  delete mode 100644 drivers/staging/ccree/dx_host.h
>>  delete mode 100644 drivers/staging/ccree/ssi_aead.c
>>  delete mode 100644 drivers/staging/ccree/ssi_aead.h
>>  delete mode 100644 drivers/staging/ccree/ssi_buffer_mgr.c
>>  delete mode 100644 drivers/staging/ccree/ssi_buffer_mgr.h
>>  delete mode 100644 drivers/staging/ccree/ssi_cipher.c
>>  delete mode 100644 drivers/staging/ccree/ssi_cipher.h
>>  delete mode 100644 drivers/staging/ccree/ssi_driver.c
>>  delete mode 100644 drivers/staging/ccree/ssi_driver.h
>>  delete mode 100644 drivers/staging/ccree/ssi_fips.c
>>  delete mode 100644 drivers/staging/ccree/ssi_fips.h
>>  delete mode 100644 drivers/staging/ccree/ssi_hash.c
>>  delete mode 100644 drivers/staging/ccree/ssi_hash.h
>>  delete mode 100644 drivers/staging/ccree/ssi_ivgen.c
>>  delete mode 100644 drivers/staging/ccree/ssi_ivgen.h
>>  delete mode 100644 drivers/staging/ccree/ssi_pm.c
>>  delete mode 100644 drivers/staging/ccree/ssi_pm.h
>>  delete mode 100644 drivers/staging/ccree/ssi_request_mgr.c
>>  delete mode 100644 drivers/staging/ccree/ssi_request_mgr.h
>>  delete mode 100644 drivers/staging/ccree/ssi_sram_mgr.c
>>  delete mode 100644 drivers/staging/ccree/ssi_sram_mgr.h
>
> Can you redo this with the -M option to git format-patch so we can see
> the files move, and not be deleted and added again?
>

Sure, I wan't aware of this option.

I will send this and the dependent patches.

Thanks,
Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
