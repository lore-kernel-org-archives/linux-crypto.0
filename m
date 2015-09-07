From: Stephan Mueller <smueller@chronox.de>
Subject: USB HID devices not linked to RNG
Date: Mon, 07 Sep 2015 02:10:16 +0200
Message-ID: <1735492.1FWVU9y0M8@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: tytso@mit.edu
To: linux-crypto@vger.kernel.org, linux-input@vger.kernel.org
Return-path: <linux-input-owner@vger.kernel.org>
Sender: linux-input-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

While analyzing the entropy sources for the random number generator in 
drivers/char/random.c, I saw that a USB mouse and a USB keyboard does trigger 
the add_input_randomness function to be triggered.

Is that intended? 

-- 
Ciao
Stephan
